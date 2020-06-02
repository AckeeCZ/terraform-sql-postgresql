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
  instance_tier          = "db-n1-standard-1" # optional, default is db-n1-standard-1
  availability_type      = "REGIONAL"         # REGIONAL for HA setup, ZONAL for single zone
  vault_secret_path      = "secret/devops/production/${var.project}/${var.environment}"
}

module "gke" {
  source            = "git::ssh://git@gitlab.ack.ee/Infra/terraform-gke-vpc.git?ref=v6.4.0"
  namespace         = var.namespace
  project           = var.project
  location          = var.zone
  vault_secret_path = var.vault_secret_path
  private           = false
  min_nodes         = 1
  max_nodes         = 2
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
