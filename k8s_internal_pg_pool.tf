resource "kubernetes_deployment" "pg_pool" {
  count = length(keys(google_sql_database_instance.read_replica)) > 0 ? 1 : 0
  metadata {
    name      = "pg-pool"
    namespace = var.namespace
    labels = {
      app = "pg-pool"
    }
  }

  spec {
    replicas = 3
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = "1"
      }
    }
    selector {
      match_labels = {
        app = "pg-pool"
      }
    }
    template {
      metadata {
        labels = {
          app = "pg-pool"
        }
      }

      spec {
        container {
          image = "bitnami/pgpool:4"
          name  = "pg-pool"
          env {
            name = "PGPOOL_BACKEND_NODES"
            value = join(
              ",",
              [
                for k in keys(var.read_replicas) :
                "${index(keys(google_sql_database_instance.read_replica), k)}:${google_sql_database_instance.read_replica[k].private_ip_address}:5432"
              ]
            )
          }
          env {
            name  = "PGPOOL_SR_CHECK_USER"
            value = local.postgres_database_user
          }
          env {
            name  = "PGPOOL_SR_CHECK_PASSWORD"
            value = google_sql_user.default.password
          }
          env {
            name  = "PGPOOL_ENABLE_LDAP"
            value = "no"
          }
          env {
            name  = "PGPOOL_POSTGRES_USERNAME"
            value = "postgres"
          }
          env {
            name  = "PGPOOL_POSTGRES_PASSWORD"
            value = google_sql_user.postgres.password
          }
          env {
            name  = "PGPOOL_HEALTH_CHECK_PERIOD"
            value = 5
          }
          env {
            name  = "PGPOOL_HEALTH_CHECK_TIMEOUT"
            value = 5
          }
          env {
            name  = "PGPOOL_HEALTH_CHECK_MAX_RETRIES"
            value = 2
          }
          env {
            name  = "PGPOOL_HEALTH_CHECK_RETRY_DELAY"
            value = 2
          }
          env {
            name  = "PGPOOL_ADMIN_USERNAME"
            value = "pgpool_admin"
          }
          env {
            name  = "PGPOOL_ADMIN_PASSWORD"
            value = "averyobfuscatedpasswordcontainingrandomcharactersandnumbersalsowithspecialsigns"
          }

          liveness_probe {
            tcp_socket {
              port = 5432
            }
            initial_delay_seconds = 10
            period_seconds        = 30
          }
          readiness_probe {
            tcp_socket {
              port = 5432
            }
            initial_delay_seconds = 10
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "pg-pool" {
  count = length(keys(google_sql_database_instance.read_replica)) > 0 ? 1 : 0
  metadata {
    name      = "sql-readers"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.pg_pool.0.metadata.0.labels.app
    }
    port {
      port        = 5432
      target_port = 5432
    }
    type = "NodePort"
  }
}
