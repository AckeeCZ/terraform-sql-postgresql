# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v5.8.0] - 2023-02-03
### Added
- add `provision_kubernetes_resources` variable, which, when set to false, allows us to provision instance without Kubernetes resources.
This is useful, for example, when provisioning Postgres to project with Cloud Run.

## [v5.7.0] - 2022-10-27
### Added
- secondary location preference variable for HA instance

## [v5.6.0] - 2022-04-20
### Added
- disk autoresize parameters

## [v5.5.0] - 2022-01-26
### Added
- custom service account name parameter
- kubernetes service name parameter

## [v5.4.0] - 2022-01-14
### Added
- read replica ip address output

## [v5.3.0] - 2022-01-13
### Added
- transaction log retention limit

## [v5.2.0] - 2021-12-31
### Added
- user labels to the cloud sql instance

## [v5.1.1] - 2021-09-21
### Removed
- unused providers definition

## [v5.1.0] - 2021-08-19
### Added
- Add `deletion_protection` input variable

## [v5.0.0] - 2021-08-13
### Removed
- Remove of `enable_local_access` due to usage of (`GoCloud`)[https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs#gocloud]

## [v4.7.0] - 2021-08-11
### Added
- Add connection name to output

## [v4.6.0] - 2021-06-03
### Added
- CloudSQL query insights configuration for read replicas

## [v4.5.1] - 2021-05-19
### Fixed
- Read replica must have ZONAL availability zone

## [v4.5.0] - 2021-05-18
### Added
- Parameterize hardcoded variables

## [v4.4.0] - 2021-05-05
### Added
- Point-in-time recovery configuration
- User suffix appended after automatically generated suffix

## [v4.3.0] - 2021-04-19
### Changed
- Remove `load_config_file` parameter from `kubernetes` provider - this allows its upgrade to version 2
- Bump `kubernetes` provider version in example

## [v4.2.0] - 2021-03-02
### Added
- CloudSQL query insights configuration

## [v4.1.0] - 2021-02-15
### Changed
- Change README usage description

## [v4.0.0] - 2021-02-04
### Removed
- Cluster master username, password
### Added
- Cluster master auth token

## [v3.0.0] - 2020-12-09
### Changed
- Required Terraform version bumped to 0.13

## [v2.16.1] - 2020-11-27
### Fixed
- Changed `google_project_service` to do not disable the service on destroy

## [v2.16.0] - 2020-11-20
### Added
- Parameter `authorized_networks` allows to add auth-networks on read replicas.

## [v2.15.0] - 2020-10-05
### Added
- Add input variable `database_flags` to enable Cloud SQL flags

## [v2.14.0] - 2020-09-17
### Added
- Array parameter `read_replicas` allows creation of CloudSQL read replicas.
- Parameter `db_version` to specify version of Postgres deployed
### Changed
- Set example GKE `cluster_name` parameter to `postgresql-cluster-test`, so it does not collide with other clusters in project
- Set example Postgres instance parameter `sqlproxy_dependencies` to `false`, because we are no longer using SQLProxy for internal connections
- Set example Postgres instance parameter `public_ip` to `true`, so `authorized_networks` parameter is applicable

## [v2.13.0] - 2020-09-17
### Changed
- Remove providers locking - this should be done in main module in infrastructure repo from now on.
- Add locking to `example/main.tf`
- Remove executable permissions from `example/spinup_testing.sh` - it should never be run directly, but must be used with `source` cmd

## [v2.12.1] - 2020-09-10
### Changed
- Upgrade random provider lock to `~> 2.3.0`

## [v2.12.0] - 2020-07-13
### Added
- Add parameter `sqlproxy_dependencies` which controls if we create SQLProxy dependencies - GCP IAM SA, Kubernetes secret and Kubernetes Service

## [v2.11.1] - 2020-07-03
### Fixed
- Fix Kubernetes Service copypaste fail - Postgres uses port 5432

## [v2.11.0] - 2020-07-02
### Added
- Add authorized networks as a module parameter to allow external public connections

## [v2.10.0] - 2020-07-02
### Added
- Add public ip to enable access to psql for external terraform provider

## [v2.9.0] - 2020-06-02
### Added
- Add a k8s service named `cloudsql` if `var.private_ip` is set to `true` targeting the private IP address of Cloud SQL
instance. Prefer this setting if your use-case allows that instead of the Cloud SQL proxy.

## [v2.8.0] - 2020-06-02
### Added
- Add pre-commit hooks for automatic documentation
- Add description on outputs and variables
- Add example on how to use the module

## [v2.7.0] - 2020-05-04
### Changed
- Upgrade Google GA provider lock to `~> 3.19.0`. Note: this upgrade should need upgrade of other TF modules to satisfy same version of `google` provider. For compatible versions, see: https://redmine.ack.ee/issues/43227#note-11

## [v2.6.0] - 2020-04-20
- Upgrade Kubernetes provider version lock to `~> 1.11.0`, to maintain compatibility with [terraform-gke-vpc](https://gitlab.ack.ee/Infra/terraform-gke-vpc/-/blob/master/main.tf) module

## [v2.5.2] - 2020-01-30
- trim account name to 30 characters

## [v2.5.1] - 2020-01-23
- fix SA name

## [v2.5.0] - 2020-01-22
- set maximum lenght of sql proxy account name to 30 characters

## [v2.4.1] - 2020-01-13
- fix vault config

## [v2.4.0] - 2020-01-13
- add required `vault_secret_path` parameter
- lock google provider

## [v2.3.0] - 2020-01-03
- log slow queries

## [v2.2.0] - 2019-12-16
- improve service account name

## [v2.1.0] - 2019-12-09
- remove random suffix from service account name

## [v2.0.1] - 2019-11-19
- remove unused name parameter

## [v2.0.0] - 2019-11-11
- upgrade to Terraform 0.12

## [v1.0.1] - 2019-11-08
- fix postgres database name

## [v1.0.0] - 2019-11-07
- initial release
