resource "vault_generic_secret" "default" {
  path      = "${var.vault_secret_path}/postgresql/passwd"
  data_json = <<EOT
{
  "postgres": "${google_sql_user.postgres.password}",
  "${local.postgres_database_user}": "${google_sql_user.default.password}"
}
EOT
}
