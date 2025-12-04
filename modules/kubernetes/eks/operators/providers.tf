provider "kubectl" {
  host                   = var.cluster_host
  cluster_ca_certificate = base64decode(var.cluster_ca)
  token                  = data.aws_eks_cluster_auth.main.token
  load_config_file       = false
}

provider "helm" {
  alias = "eks"
  kubernetes = {
    host                   = var.cluster_host
    cluster_ca_certificate = base64decode(var.cluster_ca)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", var.cluster_name,
        "--role-arn", var.cluser_ae_role_arn
      ]
    }
  }
}

provider "kubectl" {
  alias = "eks"
  host                   = var.cluster_host
  cluster_ca_certificate = base64decode(var.cluster_ca)

  load_config_file = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "/bin/sh"

    args = [
      "-c",
      "aws eks get-token --cluster-name ${var.cluster_name} --role-arn ${var.cluser_ae_role_arn} --output json"
    ]
  }
}