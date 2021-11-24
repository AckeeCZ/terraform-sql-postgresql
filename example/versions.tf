terraform {
  required_version = "1.0.11"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.85.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.88.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.4.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.7"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0.0"
    }
  }
}

