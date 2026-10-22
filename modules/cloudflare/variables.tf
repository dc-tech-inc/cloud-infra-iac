variable "zone_id" {
  description = "Cloudflare zone ID. Placeholder only."
  type        = string
  default     = "00000000000000000000000000000000"
}

variable "account_id" {
  description = "Cloudflare account ID that owns the R2 bucket. Placeholder only."
  type        = string
  default     = "11111111111111111111111111111111"
}

variable "domain" {
  description = "Apex domain managed in the zone. example.com is reserved for documentation."
  type        = string
  default     = "example.com"
}

variable "origin_ip" {
  description = "Origin server address. Defaults to an RFC 5737 documentation address."
  type        = string
  default     = "198.51.100.10"
}

variable "r2_bucket_name" {
  description = "Name of the R2 bucket (lowercase letters, digits and dashes)."
  type        = string
  default     = "demo-artifacts"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,62}$", var.r2_bucket_name))
    error_message = "r2_bucket_name must be 2-63 characters of lowercase letters, digits and dashes."
  }
}

variable "r2_location" {
  description = "R2 location hint (WNAM, ENAM, WEU, EEU or APAC)."
  type        = string
  default     = "ENAM"
}
