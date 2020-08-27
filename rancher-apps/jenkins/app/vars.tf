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