# Offline plan tests: the google provider is mocked, so no project or credentials are needed.
mock_provider "google" {}

run "network_is_custom_mode" {
  command = plan

  assert {
    condition     = google_compute_network.this.auto_create_subnetworks == false
    error_message = "Use a custom-mode VPC, not auto mode."
  }

  assert {
    condition     = google_compute_subnetwork.this.private_ip_google_access
    error_message = "Private Google access must be on."
  }
}

run "bucket_is_locked_down" {
  command = plan

  assert {
    condition     = google_storage_bucket.artifacts.uniform_bucket_level_access && google_storage_bucket.artifacts.public_access_prevention == "enforced"
    error_message = "Bucket must use uniform access and enforce public access prevention."
  }

  assert {
    condition     = google_storage_bucket.artifacts.versioning[0].enabled
    error_message = "Bucket versioning must be enabled."
  }
}

run "lb_logs_everything" {
  command = plan

  assert {
    condition     = google_compute_backend_service.app.log_config[0].enable
    error_message = "Backend service logging must be enabled."
  }
}
