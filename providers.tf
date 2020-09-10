provider "random" {
  version = "~> 2.3.0"
}

provider "google" {
  version = "~> 3.19.0"
}

provider "vault" {
  version = "~> 2.7.1"
}

provider "kubernetes" {
  version                = "~> 1.11.0"
  load_config_file       = false
  host                   = "https://${var.cluster_endpoint}"
  username               = var.cluster_user
  password               = var.cluster_pass
  cluster_ca_certificate = var.cluster_ca_certificate
}
