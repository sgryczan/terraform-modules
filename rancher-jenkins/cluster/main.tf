
// Build a Jenkins Cluster

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

data "rancher2_cluster_template" "template" {
  name = var.rke_template_name
}

data "rancher2_node_template" "template" {
  name = var.node_template_name
}

resource "rancher2_cluster" "cluster" {
    name = var.cluster_name
    cluster_template_id = data.rancher2_cluster_template.template.id
    cluster_template_revision_id = data.rancher2_cluster_template.template.template_revisions.0.id
}

resource "rancher2_node_pool" "aio" {
    count = var.single_node ? 1 : 0

    name = var.cluster_name
    cluster_id = rancher2_cluster.cluster.id
    hostname_prefix = join("", [var.cluster_name, "-"])
    node_template_id = data.rancher2_node_template.template.id
    quantity = var.num_masters
    control_plane = true
    etcd = true
    worker = true
}

resource "rancher2_node_pool" "control_plane" {
    count = var.single_node ? 0 : 1

    name = join("", [var.cluster_name, "-control-plane"])
    cluster_id = rancher2_cluster.cluster.id
    hostname_prefix = join("", [var.cluster_name, "-ctl-"])
    node_template_id = data.rancher2_node_template.template.id
    quantity = var.num_masters
    control_plane = true
    etcd = true
    worker = false
}

resource "rancher2_node_pool" "workers" {
    count = var.single_node ? 0 : 1

    name = join("", [var.cluster_name, "-workers"])
    cluster_id = rancher2_cluster.cluster.id
    hostname_prefix = join("", [var.cluster_name, "-wrk-"])
    node_template_id = data.rancher2_node_template.template.id
    quantity = var.num_workers
    control_plane = false
    etcd = false
    worker = true
}

module "external-dns" {
    depends_on = [rancher2_cluster.cluster]
    source = "git::https://github.com/sgryczan/terraform-modules.git//rancher-apps/external-dns/app?ref=dev"

    rancher_url = var.rancher_url
    rancher_token = var.rancher_token

    cluster_name = var.cluster_name
    answers = var.external_dns_values
}

locals {
    jenkins_values = base64encode(file("${path.root}/jenkins-values.yaml"))
}

module "jenkins" {
    depends_on = [rancher2_cluster.cluster]
    source = "git::https://github.com/sgryczan/terraform-modules.git//rancher-apps/jenkins/app?ref=dev"

    rancher_url = var.rancher_url
    rancher_token = var.rancher_token

    cluster_name = var.cluster_name
    chart_version = var.jenkins_chart_version
    node_pool_ids = "${var.single_node ? [rancher2_node_pool.aio[0].id] : [rancher2_node_pool.workers[0].id]}"
    values_yaml = local.jenkins_values
    create_secret = var.jenkins_create_secret
    hudson_util_secret = var.hudson_util_secret
    master_key = var.master_key
}