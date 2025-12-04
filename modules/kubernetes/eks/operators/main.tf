# resource "helm_release" "aws-load-balancer-controller" {
#   provider = helm.eks
#   name     = "aws-load-balancer-controller"

#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"

#   set = [
#     {
#       name  = "clusterName"
#       value = var.cluster_name
#     },
#     {
#       name  = "vpcId"
#       value = var.vpc_id
#     },
#     {
#       name  = "serviceAccount.create"
#       value = false
#     },
#     {
#       name  = "serviceAccount.name"
#       value = "aws-load-balancer-controller"
#     },
#   ]

#   depends_on = [kubectl_manifest.load_balancer_controller_service_account, var.node_groups_dep]
# }
