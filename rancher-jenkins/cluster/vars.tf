variable "rancher_url" {}
variable "rancher_token" {}
variable "cluster_name" {}
variable "single_node" {
    type = bool
    default = false
}
variable "num_masters" {
    default = 1
}
variable "num_workers" {
    default = 1
}
variable "node_template_name" {
    default = "default-vsphere"
}

variable "rke_template_name" {
    default = "trident-default"
}

variable "external_dns_values" {
    type = any
    default = {}
}

variable "jenkins_values" {
    default = ""
}

variable "jenkins_create_secret" {
    default = false
}

variable "hudson_util_secret" {
    default = ""
}

variable "master_key" {
    default = ""
}

variable "jenkins_chart_version" {
    default = "latest"
}