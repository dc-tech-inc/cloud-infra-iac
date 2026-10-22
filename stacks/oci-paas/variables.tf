variable "region" {
  description = "OCI region identifier."
  type        = string
  default     = "us-ashburn-1"
}

variable "compartment_ocid" {
  description = "OCID of the compartment that will own every resource."
  type        = string
  default     = "ocid1.compartment.oc1..exampleuniqueid"
}

variable "availability_domain" {
  description = "Availability domain name for the VM (list them with the OCI CLI: iam availability-domain list)."
  type        = string
  default     = "Uocm:US-ASHBURN-AD-1"
}

variable "image_ocid" {
  description = "OCID of an Ubuntu 22.04 aarch64 platform image for the chosen region."
  type        = string
  default     = "ocid1.image.oc1..exampleuniqueid"
}

variable "name" {
  description = "Name prefix applied to every resource."
  type        = string
  default     = "paas-demo"
}

variable "vcn_cidr" {
  description = "CIDR block of the VCN."
  type        = string
  default     = "10.20.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block of the public subnet (must sit inside vcn_cidr)."
  type        = string
  default     = "10.20.1.0/24"
}

variable "admin_cidr" {
  description = "Source CIDR allowed to reach SSH. Never open to the world."
  type        = string
  default     = "203.0.113.0/24" # RFC 5737 TEST-NET-3 documentation range

  validation {
    condition     = var.admin_cidr != "0.0.0.0/0" && var.admin_cidr != "::/0"
    error_message = "admin_cidr must not be open to the whole internet."
  }
}

variable "instance_ocpus" {
  description = "OCPUs for the Ampere A1 flex shape."
  type        = number
  default     = 2
}

variable "instance_memory_gbs" {
  description = "Memory in GB for the Ampere A1 flex shape."
  type        = number
  default     = 12
}

variable "ssh_public_key" {
  description = "Public SSH key installed for the default user. Placeholder only; supply your own at plan time."
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEXAMPLEEXAMPLEEXAMPLEEXAMPLEEXAMPLEEXAMPLEEX admin@example.com"
}
