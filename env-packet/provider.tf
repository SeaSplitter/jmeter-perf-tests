terraform {
  required_version = ">= 0.12"
}

provider "random" {
  version = "~> 3.0-dev"
}

provider "packet" {
  version    = "~> 1.4-dev"
  auth_token = var.auth_token
}
