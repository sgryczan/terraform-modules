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

data "rancher2_cluster" "cluster" {
  name = var.cluster_name
}

resource "rancher2_project" "project" {
  name = "Jenkins"
  
  cluster_id = data.rancher2_cluster.cluster.id
}

resource "rancher2_namespace" "namespace" {
  name = "jenkins"

  project_id = rancher2_project.project.id
}

resource "rancher2_app" "app" {
  name = "jenkins"
  catalog_name = var.catalog_name
  project_id = rancher2_project.project.id
  target_namespace = rancher2_namespace.namespace.name
  template_name = "jenkins"
  values_yaml = var.values_yaml
}