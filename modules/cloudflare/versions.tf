terraform {
  required_version = ">= 1.9.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.28"
    }
  }
}

# The API token is read from the CLOUDFLARE_API_TOKEN environment variable.
# Nothing credential-shaped lives in this repository.
