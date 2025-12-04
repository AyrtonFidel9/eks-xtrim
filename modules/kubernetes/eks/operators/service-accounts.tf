resource "kubectl_manifest" "load_balancer_controller_service_account" {
  provider = kubectl.eks
    yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: ${aws_iam_role.load-balancer-service-account.arn}
YAML

  depends_on = [ var.node_groups_dep ]
}