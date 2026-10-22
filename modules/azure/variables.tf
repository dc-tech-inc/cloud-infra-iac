variable "name" {
  description = "Name prefix applied to every resource."
  type        = string
  default     = "demo"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus"
}

variable "vnet_cidr" {
  description = "Address space of the virtual network."
  type        = string
  default     = "10.40.0.0/16"
}

variable "subnet_cidr" {
  description = "Address prefix of the workload subnet."
  type        = string
  default     = "10.40.1.0/24"
}

variable "storage_account_name" {
  description = "Globally unique storage account name (3-24 lowercase letters and digits)."
  type        = string
  default     = "demoartifacts0001"

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must be 3-24 lowercase letters and digits."
  }
}
