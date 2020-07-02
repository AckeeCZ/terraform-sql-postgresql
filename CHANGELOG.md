# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v2.10.0] - 2020-07-02
### Added
- Add public ip to enable access to psql for external terraform provider

## [v2.9.0] - 2020-06-02
### Added
- Add a k8s service named `cloudsql` if `var.private_ip` is set to `true` targeting the private IP address of Cloud SQL
instance. Prefer this setting if your use-case allows that instead of the Cloud SQL proxy.

## [v2.8.0] - 2020-06-02
### Add
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
