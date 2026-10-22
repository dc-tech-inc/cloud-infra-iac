locals {
  labels = {
    project    = var.name
    managed_by = "terraform"
  }
}

# ---- Network -------------------------------------------------------------

resource "google_compute_network" "this" {
  project                 = var.project_id
  name                    = "${var.name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  project                  = var.project_id
  name                     = "${var.name}-subnet"
  region                   = var.region
  network                  = google_compute_network.this.id
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Only Google health checkers and the load balancer front-end ranges may reach backends.
resource "google_compute_firewall" "allow_lb_health" {
  project   = var.project_id
  name      = "${var.name}-allow-lb-health"
  network   = google_compute_network.this.name
  direction = "INGRESS"

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}

# ---- Global HTTP(S) load balancer ---------------------------------------

resource "google_compute_global_address" "lb" {
  project = var.project_id
  name    = "${var.name}-lb-ip"
}

resource "google_compute_health_check" "http" {
  project = var.project_id
  name    = "${var.name}-hc"

  http_health_check {
    port         = 8080
    request_path = "/healthz"
  }
}

resource "google_compute_backend_service" "app" {
  project               = var.project_id
  name                  = "${var.name}-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [google_compute_health_check.http.id]

  log_config {
    enable      = true
    sample_rate = 1.0
  }
}

resource "google_compute_url_map" "this" {
  project         = var.project_id
  name            = "${var.name}-urlmap"
  default_service = google_compute_backend_service.app.id
}

resource "google_compute_target_http_proxy" "this" {
  project = var.project_id
  name    = "${var.name}-proxy"
  url_map = google_compute_url_map.this.id
}

resource "google_compute_global_forwarding_rule" "http" {
  project               = var.project_id
  name                  = "${var.name}-fr"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address            = google_compute_global_address.lb.id
  port_range            = "80"
  target                = google_compute_target_http_proxy.this.id
}

# ---- Bucket --------------------------------------------------------------

resource "google_storage_bucket" "artifacts" {
  project                     = var.project_id
  name                        = var.bucket_name
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  labels                      = local.labels

  versioning {
    enabled = true
  }
}
