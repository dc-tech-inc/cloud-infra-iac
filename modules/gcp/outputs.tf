output "network_id" {
  description = "ID of the VPC network."
  value       = google_compute_network.this.id
}

output "lb_ip_address" {
  description = "Reserved global IP address of the load balancer."
  value       = google_compute_global_address.lb.address
}

output "bucket_url" {
  description = "gs:// URL of the artifacts bucket."
  value       = google_storage_bucket.artifacts.url
}
