# Offline plan tests: the Cloudflare provider is mocked, so no account or token is needed.
mock_provider "cloudflare" {}

run "dns_is_proxied" {
  command = plan

  assert {
    condition     = cloudflare_record.apex.proxied && cloudflare_record.www.proxied
    error_message = "Both records must go through the Cloudflare proxy."
  }
}

run "strict_tls_zone" {
  command = plan

  assert {
    condition     = cloudflare_zone_settings_override.this.settings[0].ssl == "strict"
    error_message = "Zone must use Full (strict) TLS."
  }

  assert {
    condition     = cloudflare_zone_settings_override.this.settings[0].min_tls_version == "1.2"
    error_message = "Minimum TLS version must be 1.2."
  }
}

run "rejects_bad_bucket_name" {
  command = plan

  variables {
    r2_bucket_name = "Bad_Name"
  }

  expect_failures = [var.r2_bucket_name]
}
