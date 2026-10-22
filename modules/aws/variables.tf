variable "name" {
  description = "Name prefix applied to every resource."
  type        = string
  default     = "demo"
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC."
  type        = string
  default     = "10.30.0.0/16"
}

variable "availability_zones" {
  description = "Two availability zones for the public subnets (an ALB needs at least two)."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "An Application Load Balancer needs subnets in at least two availability zones."
  }
}

variable "public_subnet_cidrs" {
  description = "One CIDR per availability zone, all inside vpc_cidr."
  type        = list(string)
  default     = ["10.30.1.0/24", "10.30.2.0/24"]
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the HTTPS listener. Placeholder only."
  type        = string
  default     = "arn:aws:acm:us-east-1:111122223333:certificate/00000000-0000-0000-0000-000000000000"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
  default     = "demo-artifacts-example-0001"
}
