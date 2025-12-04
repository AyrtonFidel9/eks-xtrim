# Kubernetes Operator: Kiali
# Description: Configure, visualize, validate and troubleshoot your mesh! 
# Kiali is a console for Istio service mesh. Kiali can be quickly installed as an Istio add-on, 
# or trusted as a part of your development environment. See below for more about what Kiali offers, or just
# Link: https://kiali.io/docs/installation/installation-guide/

resource "kubernetes_namespace" "kiali-operator" {
  metadata {
    name = "kiali-operator"
  }
}


resource "helm_release" "kiali-operator" {
  name = "kiali-operator"

  repository = "https://kiali.org/helm-charts"
  chart      = "kiali-operator"
  namespace  = kubernetes_namespace.kiali-operator.id
  version    = "2.16.0"

  set = [
    {
      name  = "cr.create"
      value = "true"
    },
    {
      name  = "cr.namespace"
      value = "istio-system"
    },
    {
      name  = "cr.spec.auth.strategy"
      value = "anonymous"
    },
    {
      name  = "cr.spec.external_services.prometheus.url"
      value = "http://adu-prometheus-server.monitoring.svc.cluster.local:80"
    },
    {
      name  = "cr.spec.external_services.grafana.internal_url"
      value = "http://grafana.monitoring.svc.cluster.local:80"
    },
    { 
      name = "cr.spec.external_services.grafana.external_url", 
      value = "https://grafana.adu.workersbenefitfund.link/" 
    }
  ]

  depends_on = [kubernetes_namespace.kiali-operator]
}
