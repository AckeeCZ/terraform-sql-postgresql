variable "zone" {
  description = "The preferred compute engine zone"
  default     = "europe-west3-c"
  type        = string
}

variable "region" {
  description = "GCP region"
  default     = "europe-west3"
  type        = string
}

variable "project" {
  description = "GCP project name"
  type        = string
}

variable "namespace" {
  description = "K8s namespace to where insert Cloud SQL credentials secrets"
  default     = "production"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "Public CA certificate that is the root of trust for the GKE K8s cluster"
  type        = string
}

variable "cluster_token" {
  description = "Cluster master token, keep always secret!"
  type        = string
}

variable "cluster_endpoint" {
  description = "Cluster control plane endpoint"
  type        = string
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply command that deletes the instance will fail."
  default     = true
  type        = bool
}

variable "environment" {
  description = "Project enviroment, e.g. stage, production and development"
  default     = "development"
  type        = string
}

variable "instance_tier" {
  description = "The machine type to use"
  default     = "db-custom-1-3840"
  type        = string
}

variable "availability_type" {
  description = "The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL)"
  default     = "ZONAL"
  type        = string
}

variable "vault_secret_path" {
  description = "Path to secret in local vault, used mainly to save gke credentials"
  type        = string
}

variable "private_ip" {
  description = "If set to true, private IP address will get allocated and connect it to VPC network set in `var.network` in the project -- once enabled, this can't be turned off."
  default     = false
  type        = bool
}

variable "sqlproxy_dependencies" {
  description = "If set to true, we will create dependencies for running SQLproxy - GCP IAM SA, Kubernetes secret and Kubernetes Service"
  default     = true
  type        = bool
}
variable "public_ip" {
  description = "If set to true, public IP address will get allocated"
  default     = false
  type        = bool
}

variable "network" {
  description = "GCE VPC used for possible private IP addresses"
  default     = "default"
  type        = string
}

variable "authorized_networks" {
  description = "List of maps of strings authorized networks allowed to connect to Cloud SQL instance, example: [{name: the_office, cidr: 1.2.3.4/31}]"
  default     = []
  type        = list(map(string))
}

variable "read_replicas" {
  description = "Map of maps containing name as a key of read_replicas mapa and settings some parameters of read replica. For more information see README part Read replica"
  default     = {}
}

variable "db_version" {
  description = "Database version"
  default     = "POSTGRES_11"
  type        = string
}

variable "database_flags" {
  description = "The optional settings.database_flags list of values, where key is name and value is value from documentation: https://www.terraform.io/docs/providers/google/r/sql_database_instance.html"
  default     = {}
  type        = map(string)
}

variable "enable_query_insights" {
  description = "Enable query insights https://cloud.google.com/sql/docs/postgres/insights-overview"
  default     = true
  type        = bool
}

variable "query_string_length_insights" {
  description = "Insights maximum query length stored in bytes. Between 256 and 4500. Default to 1024."
  default     = 1024
  type        = number
}

variable "point_in_time_recovery" {
  description = "Enable Point-in-time recovery (effectively turns on WAL)"
  default     = false
  type        = bool
}

variable "user_suffix" {
  description = "Suffix - used, for instance, when you create a clone. Should include starting dash"
  default     = ""
  type        = string
}

variable "random_id_length" {
  description = "Byte length of random ID, used as suffix in SQL name"
  default     = 4
  type        = number
}

variable "backup_start_time" {
  description = "The time, when backup starts"
  default     = "03:00"
  type        = string
}

variable "backup_location" {
  description = "Location of backups"
  default     = "eu"
  type        = string
}

variable "maintenance_window_day" {
  description = "The day, when maintenance window will be performed"
  default     = "7"
  type        = string
}

variable "maintenance_window_hour" {
  description = "The hour, when maintenance window begins"
  default     = "4"
  type        = string
}

variable "password_length" {
  description = "Password length of postgres users"
  default     = 16
  type        = number
}

variable "log_min_duration_statement" {
  description = "Causes the duration of each completed statement to be logged if the statement ran for at least the specified number of milliseconds."
  default     = "300"
  type        = string
}

variable "cloudsql_port" {
  description = "CloudSQL's port"
  default     = 5432
  type        = number
}
