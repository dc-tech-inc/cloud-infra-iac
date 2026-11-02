terraform {
  required_version = ">= 1.9.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.10"
    }
  }
}

# Credentials come from the standard OCI environment/config chain
# (see https://registry.terraform.io/providers/oracle/oci/latest/docs). Nothing is set here.
provider "oci" {
  region = var.region
}
