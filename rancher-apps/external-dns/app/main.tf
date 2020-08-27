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
  version = "helm_v3"
}


data "rancher2_cluster" "cluster" {
  name = var.cluster_name
}

resource "rancher2_project" "project" {
  name = "external-dns"
  
  cluster_id = data.rancher2_cluster.cluster.id
}

resource "rancher2_namespace" "namespace" {
  name = "external-dns"

  project_id = rancher2_project.project.id
}

resource "rancher2_app" "app" {
  name = "external-dns"
  catalog_name = rancher2_catalog.bitnami.name
  project_id = rancher2_project.project.id
  target_namespace = rancher2_namespace.namespace.name
  template_name = "external-dns"
  answers = var.answers
}