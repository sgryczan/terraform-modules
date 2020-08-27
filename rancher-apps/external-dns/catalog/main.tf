terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
  }
}

provider "rancher2" {
  api_url = var.rancher_url
  token_key = var.rancher_token
  insecure = true
}

resource "rancher2_catalog" "bitnami" {
  name = "bitnami"
  url = "https://charts.bitnami.com/bitnami"
}
