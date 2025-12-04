resource "helm_release" "istiod" {
  name = "istiod"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = kubernetes_namespace.istio-system.id
  version          = "1.27.1"

  set = [
    {
      name  = "telemetry.enabled"
      value = "true"
    },
    {
      name  = "global.istioNamespace"
      value = kubernetes_namespace.istio-system.id
    },
    {
      name  = "meshConfig.ingressService"
      value = "istio-gateway"
    },
    {
      name  = "meshConfig.ingressSelector"
      value = "gateway"
    }
  ]

  depends_on = [ kubernetes_namespace.istio-system, helm_release.istio_base ]
}
