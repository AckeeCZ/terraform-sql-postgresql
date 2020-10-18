provider "random" {
  version = "~> 3.0.0"
}

provider "google" {
  version = "~> 3.43.0"
}

provider "google-beta" {
  version = "~> 3.43.0"
}

provider "vault" {
  version = "~> 2.14.0"
}

provider "kubernetes" {
  version = "~> 1.13.2"
}

provider "helm" {
  version = "~> 1.1"
}

provider "http" {
  version = "~> 2.0"
}


module "postgresql" {
  source                 = "../"
  project                = var.project
  region                 = var.region
  zone                   = var.zone
  namespace              = var.namespace
  cluster_ca_certificate = module.gke.cluster_ca_certificate
  cluster_user           = module.gke.cluster_username
  cluster_pass           = module.gke.cluster_password
  cluster_endpoint       = module.gke.endpoint
  environment            = "production"
  availability_type      = "REGIONAL" # REGIONAL for HA setup, ZONAL for single zone
  vault_secret_path      = "secret/devops/production/${var.project}/${var.environment}"
  enable_local_access    = true
  private_ip             = true
  public_ip              = true
  sqlproxy_dependencies  = false
  authorized_networks = [
    {
      name : "office"
      cidr : "1.2.3.4/31"
    }
  ]
  read_replicas = {
    replica-a : {
      instance_tier = "db-custom-1-3840"
      ipv4_enabled  = false
      zone          = "europe-west3-a"
    },
    replica-b : {
      instance_tier = "db-custom-1-3840"
      ipv4_enabled  = false
      zone          = "europe-west3-b"
    },
  }
  database_flags = {
    log_connections : "on"
  }
}

module "gke" {
  source            = "git::ssh://git@gitlab.ack.ee/Infra/terraform-gke-vpc.git?ref=v7.2.0"
  cluster_name      = "postgresql-cluster-test"
  namespace         = var.namespace
  project           = var.project
  location          = var.zone
  vault_secret_path = var.vault_secret_path
  private           = false
  min_nodes         = 1
  max_nodes         = 2
}

output "psql_ip" {
  value = module.postgresql.postgres_instance_ip_settings.0.ip_address
}

variable "environment" {
  default = "development"
}

variable "namespace" {
  default = "stage"
}

variable "project" {
}

variable "vault_secret_path" {
}

variable "region" {
  default = "europe-west3"
}

variable "zone" {
  default = "europe-west3-c"
}
