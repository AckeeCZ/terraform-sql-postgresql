data "google_compute_network" "default" {
  name = var.network
}

resource "random_id" "instance_name_suffix" {
  byte_length = var.random_id_length
}

locals {
  instance_name                 = "${var.project}-${var.environment}-${random_id.instance_name_suffix.hex}${var.user_suffix}"
  sqlproxy_service_account_name = var.sqlproxy_service_account_name == null ? substr("sqlproxy-postgres-${var.environment}", 0, 30) : var.sqlproxy_service_account_name
  project_name_normalized       = replace(var.project, "-", "_")
  postgres_database_name        = local.project_name_normalized
  postgres_database_user        = local.postgres_database_name
  database_flags = merge({
    log_min_duration_statement : var.log_min_duration_statement
  }, var.database_flags)
  kubernetes_stuff = (var.provision_kubernetes_resources && var.private_ip)
}

resource "google_project_service" "enable_sqladmin_api" {
  service            = "sqladmin.googleapis.com"
  project            = var.project
  disable_on_destroy = false
}

resource "google_service_account" "sqlproxy" {
  account_id   = substr(local.sqlproxy_service_account_name, 0, 30)
  display_name = local.sqlproxy_service_account_name
  description  = "SA for PostgreSQL sqlproxy. Automatically created by terraform-postgresql module."
  project      = var.project
  count        = var.sqlproxy_dependencies ? 1 : 0
}

resource "google_project_iam_member" "sqlproxy_role" {
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.sqlproxy[0].email}"
  project = var.project
  count   = var.sqlproxy_dependencies ? 1 : 0
}

resource "google_service_account_key" "sqlproxy" {
  service_account_id = google_service_account.sqlproxy[0].name
  count              = var.sqlproxy_dependencies ? 1 : 0
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
  name                = local.instance_name
  database_version    = var.db_version
  region              = var.region
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.instance_tier
    availability_type = var.availability_type

    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit

    backup_configuration {
      enabled                        = true
      start_time                     = var.backup_start_time
      point_in_time_recovery_enabled = var.point_in_time_recovery
      location                       = var.backup_location
      transaction_log_retention_days = var.transaction_log_retention_days
    }

    location_preference {
      zone           = var.zone
      secondary_zone = var.secondary_zone
    }

    maintenance_window {
      day  = var.maintenance_window_day
      hour = var.maintenance_window_hour
    }

    dynamic "database_flags" {
      for_each = local.database_flags
      content {
        name  = database_flags.key
        value = database_flags.value
      }
    }

    insights_config {
      query_insights_enabled  = var.enable_query_insights
      query_string_length     = var.query_string_length_insights
      record_application_tags = true
      record_client_address   = true
    }

    ip_configuration {
      private_network = var.private_ip ? data.google_compute_network.default.self_link : null
      ipv4_enabled    = var.public_ip ? true : false

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.cidr
        }
      }
    }
    user_labels = var.user_labels
  }
  depends_on = [google_project_service.enable_sqladmin_api]
}

resource "google_sql_database_instance" "read_replica" {
  for_each             = var.read_replicas
  name                 = "${google_sql_database_instance.default.name}-${each.key}"
  master_instance_name = google_sql_database_instance.default.name
  region               = var.region
  database_version     = var.db_version
  deletion_protection  = var.deletion_protection

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = lookup(each.value, "instance_tier", "db-custom-1-3840")
    availability_type = "ZONAL"

    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit

    backup_configuration {
      enabled = false
    }

    dynamic "database_flags" {
      for_each = local.database_flags
      content {
        name  = database_flags.key
        value = database_flags.value
      }
    }

    dynamic "insights_config" {
      for_each = var.enable_query_insights ? [1] : []
      content {
        query_insights_enabled  = var.enable_query_insights
        query_string_length     = var.query_string_length_insights
        record_application_tags = true
        record_client_address   = true
      }
    }

    ip_configuration {

      ipv4_enabled    = lookup(each.value, "ipv4_enabled", false)
      private_network = var.private_ip ? data.google_compute_network.default.self_link : null

      dynamic "authorized_networks" {
        for_each = lookup(each.value, "authorized_networks", [])
        content {
          name  = authorized_networks.value["name"]
          value = authorized_networks.value["cidr"]
        }
      }
    }

    location_preference {
      zone = lookup(each.value, "zone", var.zone)
    }
  }
  depends_on = [google_sql_database_instance.default]
}

resource "random_password" "postgres_postgres" {
  length           = var.password_length
  special          = true
  override_special = "/@_%"
}

resource "random_password" "postgres_default" {
  length           = var.password_length
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
    GCP_SERVICE_ACCOUNT_KEY = base64decode(google_service_account_key.sqlproxy[0].private_key)
  }
  count = var.sqlproxy_dependencies ? 1 : 0

}
