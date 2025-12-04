resource "helm_release" "istio_base" {
  name = "istio-base"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = kubernetes_namespace.istio-system.id
  version          = "1.27.1"

  set = [
    {
      name  = "global.istioNamespace"
      value = "istio-system"
    }
  ]

  depends_on = [ kubernetes_namespace.istio-system ]
}
