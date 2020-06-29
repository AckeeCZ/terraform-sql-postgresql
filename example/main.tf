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

provider "postgresql" {
  host            = module.postgresql.postgres_instance_ip_settings.0.ip_address
  port            = 5432
  database        = replace(var.project, "-", "_")
  username        = replace(var.project, "-", "_")
  password        = module.postgresql.postgres_default_password
  sslmode         = "require"
  connect_timeout = 15
}

resource "postgresql_extension" "pg_trgm" {
  name       = "pg_trgm"
  depends_on = [module.postgresql.postgres_instance_ip_settings]
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
