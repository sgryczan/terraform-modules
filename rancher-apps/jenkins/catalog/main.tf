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

resource "rancher2_catalog" "helm-stable-v2" {
  name = "helm-stable-v2"
  url = "https://kubernetes-charts.storage.googleapis.com"
  version = "helm_v2"
}

resource "rancher2_catalog" "helm-stable-v3" {
  name = "helm-stable-v3"
  url = "https://kubernetes-charts.storage.googleapis.com"
  version = "helm_v3"
}
