provider "random" {
}

provider "google" {
}

provider "vault" {
}

provider "http" {
}

provider "postgresql" {
}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${var.cluster_endpoint}"
  username               = var.cluster_user
  password               = var.cluster_pass
  cluster_ca_certificate = var.cluster_ca_certificate
}
