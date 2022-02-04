resource "kubernetes_endpoints" "cloudsql" {
  count = var.private_ip ? 1 : 0

  metadata {
    name      = var.kubernetes_service_name
    namespace = var.namespace
  }

  subset {
    address {
      ip = google_sql_database_instance.default.private_ip_address
    }

    port {
      port = var.cloudsql_port
    }
  }
}

resource "kubernetes_service" "cloudsql" {
  count = var.private_ip ? 1 : 0

  metadata {
    name      = var.kubernetes_service_name
    namespace = var.namespace
  }

  spec {
    port {
      port        = var.cloudsql_port
      target_port = var.cloudsql_port
    }
  }
}
