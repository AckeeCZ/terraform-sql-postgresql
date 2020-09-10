# Terraform Google Cloud SQL Postgres module with K8s secret deploy

Terraform module for provisioning GCP SQL Postgres database. It should also deploy the username and password to K8s
as a secret. That could be used in setting up cloudsql proxy pod.

## Usage

```hcl
module "postgresql" {
  source = "git::ssh://git@gitlab.ack.ee/Infra/terraform-postgresql.git?ref=v2.11.0"
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
  vault_secret_path = "secret/devops/generated/${TYPE}/${var.project}/${var.environment}" # ${TYPE} should be set to internal for internal projects, external for external projects
}
```

## Before you do anything in this module

Install pre-commit hooks by running following commands:

```shell script
brew install pre-commit terraform-docs
pre-commit install
```

## Dependencies

GKE module: https://gitlab.ack.ee/Infra/terraform-gke-vpc

## Example SQL proxy specification

[proxy.yaml](https://gitlab.ack.ee/Ackee/infrastruktura-templates/blob/master/k8s/production/services/proxy.yaml) in infrastuktura-template repo

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| google | ~> 3.19.0 |
| kubernetes | ~> 1.11.0 |
| random | ~> 2.3.0 |
| vault | ~> 2.7.1 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.19.0 |
| http | n/a |
| kubernetes | ~> 1.11.0 |
| random | ~> 2.3.0 |
| vault | ~> 2.7.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authorized\_networks | List of maps of strings authorized networks allowed to connect to Cloud SQL instance, example: [{name: the\_office, cidr: 1.2.3.4/31}] | `list(map(string))` | `[]` | no |
| availability\_type | The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL) | `string` | `"ZONAL"` | no |
| cluster\_ca\_certificate | Public CA certificate that is the root of trust for the GKE K8s cluster | `string` | n/a | yes |
| cluster\_endpoint | Cluster control plane endpoint | `string` | n/a | yes |
| cluster\_pass | Cluster master password, keep always secret! | `string` | n/a | yes |
| cluster\_user | Cluster master username, keep always secret! | `string` | n/a | yes |
| enable\_local\_access | Enable access from your local public IP to allow some postprocess PSQL operations | `bool` | `false` | no |
| environment | Project enviroment, e.g. stage, production and development | `string` | `"development"` | no |
| instance\_tier | The machine type to use | `string` | `"db-custom-1-3840"` | no |
| namespace | K8s namespace to where insert Cloud SQL credentials secrets | `string` | `"production"` | no |
| network | GCE VPC used for possible private IP addresses | `string` | `"default"` | no |
| private\_ip | If set to true, private IP address will get allocated and connect it to VPC network set in `var.network` in the project -- once enabled, this can't be turned off. | `bool` | `false` | no |
| project | GCP project name | `string` | n/a | yes |
| public\_ip | If set to true, public IP address will get allocated | `bool` | `false` | no |
| region | GCP region | `string` | `"europe-west3"` | no |
| sqlproxy\_dependencies | If set to true, we will create dependencies for running SQLproxy - GCP IAM SA, Kubernetes secret and Kubernetes Service | `bool` | `true` | no |
| vault\_secret\_path | Path to secret in local vault, used mainly to save gke credentials | `string` | n/a | yes |
| zone | The preferred compute engine zone | `string` | `"europe-west3-c"` | no |

## Outputs

| Name | Description |
|------|-------------|
| postgres\_default\_password | PSQL password to default user |
| postgres\_instance\_ip\_settings | PSQL instance IP address settings |
| postgres\_instance\_name | PSQL instance name |
| postgres\_postgres\_password | PSQL password to postgres user |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
