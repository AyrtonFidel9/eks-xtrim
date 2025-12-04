# Kubernetes Operator: Certmanager
# Description:cert-manager creates TLS certificates for workloads in your Kubernetes or OpenShift cluster 
# and renews the certificates before they expire.
# Link: https://cert-manager.io/docs/

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "helm_release" "cert_manager" {
  name = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = kubernetes_namespace.cert_manager.id
  version          = "1.19.0"

  set = [ {
    name = "crds.enabled"
    value = true
  } ]

  depends_on = [ kubernetes_namespace.cert_manager ]
}