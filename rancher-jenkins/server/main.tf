
// Ensure the catalogs are in place, since we'll reference these when deploying clusters

module "bitnami-catalog" {
    source = "git::https://github.com/sgryczan/terraform-modules.git//rancher-apps/external-dns/catalog?ref=dev"
    rancher_url = var.rancher_url
    rancher_token = var.rancher_token
}

module "jenkins-catalog" {
    source = "git::https://github.com/sgryczan/terraform-modules.git//rancher-apps/jenkins/catalog?ref=dev"
    rancher_url = var.rancher_url
    rancher_token = var.rancher_token
}
