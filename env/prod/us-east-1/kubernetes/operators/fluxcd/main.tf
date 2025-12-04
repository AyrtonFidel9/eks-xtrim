# FluxCD Operator: Cloud Native PG (CNPG)
# Description: Flux is a tool for keeping Kubernetes clusters in sync with sources of configuration 
#(like Git repositories), and automating updates to configuration when there is new code to deploy.
# Flux is built from the ground up to use Kubernetes' API extension system, and to integrate with 
# Prometheus and other core components of the Kubernetes ecosystem. Flux supports multi-tenancy 
# and support for syncing an arbitrary number of Git repositories.

# Link: https://fluxcd.io/flux/

resource "kubernetes_namespace" "flux-system" {
  metadata {
    name = "flux-system"
    labels = {
      "istio-injection" = "enabled"
      "app.kubernetes.io/instance" = "flux-system"
      "app.kubernetes.io/part-of"  = "flux"
      "app.kubernetes.io/version"  = "v2.7.3"      
      "kustomize.toolkit.fluxcd.io/name"      = "flux-system"
      "kustomize.toolkit.fluxcd.io/namespace" = "flux-system"
    }
  }
}

resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "gitlab_deploy_key" "flux-token" {
  project = "workersbenefitfund/adu-infrastructure"
  title   = "flux-cd-token"
  key     = tls_private_key.flux.public_key_openssh
  can_push = true
}

resource "flux_bootstrap_git" "this" {
  depends_on = [gitlab_deploy_key.flux-token, kubernetes_namespace.flux-system]

  embedded_manifests = true
  path               = "env/${var.env.short}/${var.region}/kubernetes/cluster/gitops-cd"
}