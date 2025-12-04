resource "helm_release" "istio-gateway" {
  name = "gateway"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = kubernetes_namespace.istio-ingress.id
  version    = "1.27.1"
  
  set = [
    # {
    #   name = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    #   value = "external"
    # },
    # {
    #   name = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    #   value = "internet-facing"
    # },
    # {
    #   name = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-name"
    #   value = "adu-loadbalancer-gateway"
    # },
    {
      name = "service.type"
      value = "ClusterIP"
    }
  ]

  depends_on = [kubernetes_namespace.istio-ingress, helm_release.istio_base, helm_release.istiod]
}
