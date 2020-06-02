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
