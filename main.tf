data "google_compute_network" "default" {
  name = var.network
}

resource "random_id" "instance_name_suffix" {
  byte_length = 4
}

locals {
  instance_name                 = "${var.project}-${var.environment}-${random_id.instance_name_suffix.hex}"
  sqlproxy_service_account_name = substr("sqlproxy-postgres-${var.environment}", 0, 30)
  project_name_normalized       = replace(var.project, "-", "_")
  postgres_database_name        = local.project_name_normalized
  postgres_database_user        = local.postgres_database_name
}

resource "google_project_service" "enable_sqladmin_api" {
  service = "sqladmin.googleapis.com"
  project = var.project
}

resource "google_service_account" "sqlproxy" {
  account_id   = substr(local.sqlproxy_service_account_name, 0, 30)
  display_name = local.sqlproxy_service_account_name
  description  = "SA for PostgreSQL sqlproxy. Automatically created by terraform-postgresql module."
  project      = var.project
}

resource "google_project_iam_member" "sqlproxy_role" {
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.sqlproxy.email}"
  project = var.project
}

resource "google_service_account_key" "sqlproxy" {
  service_account_id = google_service_account.sqlproxy.name
}

resource "google_project_service" "enable-servicenetworking-api" {
  service = "servicenetworking.googleapis.com"
  project = var.project

  disable_on_destroy = false
  count              = var.private_ip ? 1 : 0
}

resource "google_compute_global_address" "psql_private_ip_address" {
  name          = "${local.instance_name}-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.default.self_link
  count         = var.private_ip ? 1 : 0
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = data.google_compute_network.default.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psql_private_ip_address[0].name]
  count                   = var.private_ip ? 1 : 0
}

resource "google_sql_database_instance" "default" {
  name             = local.instance_name
  database_version = "POSTGRES_11"
  region           = var.region

  settings {
    tier              = var.instance_tier
    availability_type = var.availability_type

    backup_configuration {
      enabled    = true
      start_time = "03:00"
    }

    location_preference {
      zone = var.zone
    }

    maintenance_window {
      day  = "7"
      hour = "4"
    }

    database_flags {
      name  = "log_min_duration_statement"
      value = "300"
    }

    ip_configuration {
      private_network = var.private_ip ? data.google_compute_network.default.self_link : null
    }

  }
  depends_on = [google_project_service.enable_sqladmin_api]
}

resource "random_password" "postgres_postgres" {
  length           = 16
  special          = true
  override_special = "/@_%"
}

resource "random_password" "postgres_default" {
  length           = 16
  special          = true
  override_special = "/@_%"
}

resource "google_sql_user" "postgres" {
  name       = "postgres"
  instance   = google_sql_database_instance.default.name
  password   = random_password.postgres_postgres.result
  depends_on = [google_sql_database_instance.default]
}

resource "google_sql_user" "default" {
  name       = local.postgres_database_user
  instance   = google_sql_database_instance.default.name
  password   = random_password.postgres_default.result
  depends_on = [google_sql_database_instance.default]
}

resource "google_sql_database" "default" {
  name       = local.postgres_database_name
  project    = var.project
  instance   = google_sql_database_instance.default.name
  charset    = "UTF8"
  collation  = "en_US.UTF8"
  depends_on = [google_sql_database_instance.default]
}

resource "kubernetes_secret" "sqlproxy" {
  metadata {
    name      = "sqlproxy-cfg-${var.environment}"
    namespace = var.namespace
  }

  data = {
    SQL_CONNECTION_NAME     = google_sql_database_instance.default.connection_name
    GCP_SERVICE_ACCOUNT_KEY = base64decode(google_service_account_key.sqlproxy.private_key)
  }
}

