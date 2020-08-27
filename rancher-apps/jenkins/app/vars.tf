variable "rancher_url" {}
variable "rancher_token" {}

variable "cluster_name" {}

variable "values_yaml" {
    description = "values.yaml base64 encoded file content"
    default = ""
}

variable "catalog_name" {
    default = "helm-stable-v3"
}

variable "create_secret" {
    type = bool
    default = false
}

variable "hudson_util_secret" {
    default = ""
}

variable "master_key" {
    default = ""
}