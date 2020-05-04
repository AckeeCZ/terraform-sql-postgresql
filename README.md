# Terraform Google Cloud SQL Postgres module

## Usage

```hcl
module "postgresql" {
  name = "postgresql"
  source = "git::ssh://git@gitlab.ack.ee/Infra/terraform-postgresql.git?ref=v1.0.0"
  project = "${var.project}"
  region = "${var.region}"
  zone = "${var.zone}"
  namespace = "${var.namespace}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
  cluster_user = "${module.gke.cluster_username}"
  cluster_pass = "${module.gke.cluster_password}"
  cluster_endpoint = "${module.gke.endpoint}"
  environment = "production"
  instance_tier = "db-n1-standard-1" # optional, default is db-n1-standard-1
  availability_type = "REGIONAL" # REGIONAL for HA setup, ZONAL for single zone
  vault_secret_path = "secret/devops/${TYPE}/${var.project}/${var.environment}" # ${TYPE} should be set to internal for internal projects, external for external projects
}
```

## Dependencies

GKE module : https://gitlab.ack.ee/Infra/terraform-gke-vpc

## Example SQL proxy specification

[proxy.yaml](https://gitlab.ack.ee/Ackee/infrastruktura-templates/blob/master/k8s/production/services/proxy.yaml) in infrastuktura-template repo
