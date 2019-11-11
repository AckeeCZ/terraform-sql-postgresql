output "postgres_postgres_password" {
  value = google_sql_user.postgres.password
}

output "postgres_default_password" {
  value = google_sql_user.default.password
}

