variable "project_id" {
  description = "GCP project ID. Placeholder only."
  type        = string
  default     = "example-project-0001"
}

variable "region" {
  description = "GCP region."
  type        = string
  default     = "us-central1"
}

variable "name" {
  description = "Name prefix applied to every resource."
  type        = string
  default     = "demo"
}

variable "subnet_cidr" {
  description = "CIDR range of the regional subnet."
  type        = string
  default     = "10.50.1.0/24"
}

variable "bucket_name" {
  description = "Globally unique Cloud Storage bucket name."
  type        = string
  default     = "demo-artifacts-example-0001"
}
