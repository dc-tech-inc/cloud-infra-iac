# DNS: apex and www both point at the origin through Cloudflare's proxy (CDN + WAF in front).
resource "cloudflare_record" "apex" {
  zone_id = var.zone_id
  name    = "@"
  type    = "A"
  content = var.origin_ip
  proxied = true
  ttl     = 1 # 1 = automatic, required when proxied
  comment = "Managed by Terraform"
}

resource "cloudflare_record" "www" {
  zone_id = var.zone_id
  name    = "www"
  type    = "CNAME"
  content = var.domain
  proxied = true
  ttl     = 1
  comment = "Managed by Terraform"
}

# CDN and TLS posture for the whole zone.
resource "cloudflare_zone_settings_override" "this" {
  zone_id = var.zone_id

  settings {
    ssl                      = "strict"
    always_use_https         = "on"
    min_tls_version          = "1.2"
    automatic_https_rewrites = "on"
    brotli                   = "on"
  }
}

# Object storage compatible with the S3 API.
resource "cloudflare_r2_bucket" "artifacts" {
  account_id = var.account_id
  name       = var.r2_bucket_name
  location   = var.r2_location
}
