# Kubernetes Operator: Cloud Native PG (CNPG)
# Description: CloudNativePG (CNPG) is an open-source platform designed to seamlessly 
# manage PostgreSQL databases in Kubernetes environments. It covers the entire operational 
# lifecycle—from deployment to ongoing maintenance—through its core component,
# the CloudNativePG operator.
# Link: https://cloudnative-pg.io/

resource "kubernetes_namespace" "cnpg-system" {
  metadata {
    name = "cnpg-system"
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "helm_release" "cnpg" {
  name = "cnpg"

  repository       = "https://cloudnative-pg.github.io/charts"
  chart            = "cloudnative-pg"
  namespace        = kubernetes_namespace.cnpg-system.id
  version          = "0.26.0"

  depends_on = [ kubernetes_namespace.cnpg-system ]
}

locals {
  barman_docs = split(
    "---",
    file("${path.module}/crds/barman.yaml")
  )
}

resource "kubernetes_manifest" "barman" {
  for_each = {
    for idx, doc in local.barman_docs :
    idx => yamldecode(trimspace(doc))
    if trimspace(doc) != ""
  }

  manifest = each.value
}