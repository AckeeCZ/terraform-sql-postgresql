output "postgres_postgres_password" {
  description = "PSQL password to postgres user"
  value       = google_sql_user.postgres.password
}

output "postgres_default_password" {
  description = "PSQL password to default user"
  value       = google_sql_user.default.password
}

output "postgres_instance_name" {
  description = "PSQL instance name"
  value       = google_sql_database_instance.default.name
}

output "postgres_instance_connection_name" {
  description = "PSQL instance connection name"
  value       = google_sql_database_instance.default.connection_name
}

output "postgres_instance_ip_settings" {
  description = "PSQL instance IP address settings"
  value       = google_sql_database_instance.default.ip_address
}

output "postgres_reader_instance_ip_settings" {
  description = "PSQL instance IP address settings of read replicas"
  value       = { for k, _ in var.read_replicas : k => google_sql_database_instance.read_replica[k].ip_address }
}
