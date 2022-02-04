# Terraform Google Cloud SQL Postgres module with K8s secret deploy

Terraform module for provisioning GCP SQL Postgres database. It should also deploy the username and password to K8s
as a secret. That could be used in setting up cloudsql proxy pod.

## Usage

```hcl
module "postgresql" {
  source  = "AckeeCZ/postgresql/sql"

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
}
```

## Read replicas

Read replicas are configured from `read_replicas` parameter map. Key serve as replica name, it is appended to primary's `instance_name` local variable.

Every read replica have four parameters:
* `instance_tier`: Instance type for replica, equivalent of primary's `instance_tier` parameter.
* `ipv4_enabled`: Availability of public IP address on replica, equivalent of primary's `ipv4_enabled` parameter.
* `zone`: Zone where read replicas is deployed. This is bit different from primary's `zone` parameter. On primary instance, we define "prefered location"
* `authorized_networks`: List of maps of strings authorized networks allowed to connect to Cloud SQL Read Replica Instance, example: [{name: the_office, cidr: 1.2.3.4/31}] This parameter is `optional`.
- HA instance will change it's location in case of failover, but read replicas have zone "hard set".

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_global_address.psql_private_ip_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_project_iam_member.sqlproxy_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.enable-servicenetworking-api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.enable_sqladmin_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.sqlproxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.sqlproxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [google_service_networking_connection.private_vpc_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |
| [google_sql_database.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_database_instance.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) | resource |
| [google_sql_database_instance.read_replica](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) | resource |
| [google_sql_user.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [google_sql_user.postgres](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [kubernetes_endpoints.cloudsql](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/endpoints) | resource |
| [kubernetes_secret.sqlproxy](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.cloudsql](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [random_id.instance_name_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.postgres_default](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_postgres](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [vault_generic_secret.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [google_compute_network.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | List of maps of strings authorized networks allowed to connect to Cloud SQL instance, example: [{name: the\_office, cidr: 1.2.3.4/31}] | `list(map(string))` | `[]` | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL) | `string` | `"ZONAL"` | no |
| <a name="input_backup_location"></a> [backup\_location](#input\_backup\_location) | Location of backups | `string` | `"eu"` | no |
| <a name="input_backup_start_time"></a> [backup\_start\_time](#input\_backup\_start\_time) | The time, when backup starts | `string` | `"03:00"` | no |
| <a name="input_cloudsql_port"></a> [cloudsql\_port](#input\_cloudsql\_port) | CloudSQL's port | `number` | `5432` | no |
| <a name="input_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#input\_cluster\_ca\_certificate) | Public CA certificate that is the root of trust for the GKE K8s cluster | `string` | n/a | yes |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | Cluster control plane endpoint | `string` | n/a | yes |
| <a name="input_cluster_token"></a> [cluster\_token](#input\_cluster\_token) | Cluster master token, keep always secret! | `string` | n/a | yes |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | The optional settings.database\_flags list of values, where key is name and value is value from documentation: https://www.terraform.io/docs/providers/google/r/sql_database_instance.html | `map(string)` | `{}` | no |
| <a name="input_db_version"></a> [db\_version](#input\_db\_version) | Database version | `string` | `"POSTGRES_11"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply command that deletes the instance will fail. | `bool` | `true` | no |
| <a name="input_enable_query_insights"></a> [enable\_query\_insights](#input\_enable\_query\_insights) | Enable query insights https://cloud.google.com/sql/docs/postgres/insights-overview | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Project enviroment, e.g. stage, production and development | `string` | `"development"` | no |
| <a name="input_instance_tier"></a> [instance\_tier](#input\_instance\_tier) | The machine type to use | `string` | `"db-custom-1-3840"` | no |
| <a name="input_kubernetes_service_name"></a> [kubernetes\_service\_name](#input\_kubernetes\_service\_name) | Name of kubernetes service | `string` | `"cloudsql"` | no |
| <a name="input_log_min_duration_statement"></a> [log\_min\_duration\_statement](#input\_log\_min\_duration\_statement) | Causes the duration of each completed statement to be logged if the statement ran for at least the specified number of milliseconds. | `string` | `"300"` | no |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | The day, when maintenance window will be performed | `string` | `"7"` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | The hour, when maintenance window begins | `string` | `"4"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | K8s namespace to where insert Cloud SQL credentials secrets | `string` | `"production"` | no |
| <a name="input_network"></a> [network](#input\_network) | GCE VPC used for possible private IP addresses | `string` | `"default"` | no |
| <a name="input_password_length"></a> [password\_length](#input\_password\_length) | Password length of postgres users | `number` | `16` | no |
| <a name="input_point_in_time_recovery"></a> [point\_in\_time\_recovery](#input\_point\_in\_time\_recovery) | Enable Point-in-time recovery (effectively turns on WAL) | `bool` | `false` | no |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | If set to true, private IP address will get allocated and connect it to VPC network set in `var.network` in the project -- once enabled, this can't be turned off. | `bool` | `false` | no |
| <a name="input_project"></a> [project](#input\_project) | GCP project name | `string` | n/a | yes |
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | If set to true, public IP address will get allocated | `bool` | `false` | no |
| <a name="input_query_string_length_insights"></a> [query\_string\_length\_insights](#input\_query\_string\_length\_insights) | Insights maximum query length stored in bytes. Between 256 and 4500. Default to 1024. | `number` | `1024` | no |
| <a name="input_random_id_length"></a> [random\_id\_length](#input\_random\_id\_length) | Byte length of random ID, used as suffix in SQL name | `number` | `4` | no |
| <a name="input_read_replicas"></a> [read\_replicas](#input\_read\_replicas) | Map of maps containing name as a key of read\_replicas mapa and settings some parameters of read replica. For more information see README part Read replica | `map` | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west3"` | no |
| <a name="input_sqlproxy_dependencies"></a> [sqlproxy\_dependencies](#input\_sqlproxy\_dependencies) | If set to true, we will create dependencies for running SQLproxy - GCP IAM SA, Kubernetes secret and Kubernetes Service | `bool` | `true` | no |
| <a name="input_sqlproxy_service_account_name"></a> [sqlproxy\_service\_account\_name](#input\_sqlproxy\_service\_account\_name) | SQL instance service account name | `string` | `null` | no |
| <a name="input_transaction_log_retention_days"></a> [transaction\_log\_retention\_days](#input\_transaction\_log\_retention\_days) | The number of days of transaction logs we retain for point in time restore, from 1-7. | `number` | `null` | no |
| <a name="input_user_labels"></a> [user\_labels](#input\_user\_labels) | Labels to the instance | `map(string)` | `{}` | no |
| <a name="input_user_suffix"></a> [user\_suffix](#input\_user\_suffix) | Suffix - used, for instance, when you create a clone. Should include starting dash | `string` | `""` | no |
| <a name="input_vault_secret_path"></a> [vault\_secret\_path](#input\_vault\_secret\_path) | Path to secret in local vault, used mainly to save gke credentials | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | The preferred compute engine zone | `string` | `"europe-west3-c"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_postgres_default_password"></a> [postgres\_default\_password](#output\_postgres\_default\_password) | PSQL password to default user |
| <a name="output_postgres_instance_connection_name"></a> [postgres\_instance\_connection\_name](#output\_postgres\_instance\_connection\_name) | PSQL instance connection name |
| <a name="output_postgres_instance_ip_settings"></a> [postgres\_instance\_ip\_settings](#output\_postgres\_instance\_ip\_settings) | PSQL instance IP address settings |
| <a name="output_postgres_instance_name"></a> [postgres\_instance\_name](#output\_postgres\_instance\_name) | PSQL instance name |
| <a name="output_postgres_postgres_password"></a> [postgres\_postgres\_password](#output\_postgres\_postgres\_password) | PSQL password to postgres user |
| <a name="output_postgres_reader_instance_ip_settings"></a> [postgres\_reader\_instance\_ip\_settings](#output\_postgres\_reader\_instance\_ip\_settings) | PSQL instance IP address settings of read replicas |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
