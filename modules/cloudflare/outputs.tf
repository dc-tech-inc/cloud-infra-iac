output "apex_record_name" {
  description = "Name of the proxied apex DNS record."
  value       = cloudflare_record.apex.name
}

output "r2_bucket_name" {
  description = "Name of the R2 bucket."
  value       = cloudflare_r2_bucket.artifacts.name
}
