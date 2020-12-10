
terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    http = {
      source = "hashicorp/http"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    postgresql = {
      source = "cyrilgdn/postgresql"
    }
    random = {
      source = "hashicorp/random"
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
}
