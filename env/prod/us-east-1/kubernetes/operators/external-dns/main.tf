# Kubernetes Operator: External DNS
# Description: Inspired by Kubernetes DNS, Kubernetes’ cluster-internal DNS 
# server, ExternalDNS makes Kubernetes resources discoverable via public DNS servers.
# Like KubeDNS, it retrieves a list of resources (Services, Ingresses, etc.) from the
# Kubernetes API to determine a desired list of DNS records.
# Link: https://kubernetes-sigs.github.io/external-dns/latest/charts/external-dns/


resource "kubectl_manifest" "external_dns_sa" {
  provider   = kubectl.eks
  yaml_body  = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns-sa
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: ${aws_iam_role.external_dns.arn}
YAML
  depends_on = [aws_iam_role.external_dns]
}

resource "helm_release" "external_dns" {
  name = "external-dns"

  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = "kube-system"
  version    = "1.19.0"

  set = [
    {
      name  = "serviceAccount.create"
      value = false
    },
    {
      name  = "serviceAccount.name"
      value = kubectl_manifest.external_dns_sa.name
    },
    {
      name  = "provider.name"
      value = "aws"
    }
  ]

  set_list = [
    {
      name  = "sources"
      value = ["service", "ingress", "istio-gateway", "istio-virtualservice"]
    },
    {
      name  = "domainFilters"
      value = ["dev.adu.workersbenefitfund.link"] # setup with terraform data from dns outputs
    }
  ]

  depends_on = [kubectl_manifest.external_dns_sa]
}
