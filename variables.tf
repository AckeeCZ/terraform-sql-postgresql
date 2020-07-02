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

variable "cluster_user" {
  description = "Cluster master username, keep always secret!"
  type        = string
}

variable "cluster_pass" {
  description = "Cluster master password, keep always secret!"
  type        = string
}

variable "cluster_endpoint" {
  description = "Cluster control plane endpoint"
  type        = string
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

variable "enable_local_access" {
  description = "Enable access from your local public IP to allow some postprocess PSQL operations"
  default     = false
  type        = bool
}
