variable "rancher_url" {}
variable "rancher_token" {}

variable "cluster_name" {}

variable "answers" {
    type = any
    description = "Answers for external-dns Helm chart"
    default = {}
}