resource "kubernetes_endpoints" "cloudsql" {
  count = var.private_ip ? 1 : 0

  metadata {
    name      = "cloudsql"
    namespace = var.namespace
  }

  subset {
    address {
      ip = google_sql_database_instance.default.private_ip_address
    }

    port {
      port = 3306
    }
  }
}

resource "kubernetes_service" "cloudsql" {
  count = var.private_ip ? 1 : 0

  metadata {
    name      = "cloudsql"
    namespace = var.namespace
  }

  spec {
    port {
      port        = 3306
      target_port = 3306
    }
  }
}
