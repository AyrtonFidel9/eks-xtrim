provider "aws" {
  region              = var.region
  allowed_account_ids = ["528860655539"]
}

provider "helm" {
  kubernetes = {
    host                   = data.terraform_remote_state.adu_eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.adu_eks.outputs.cluster_certificate_authority)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.adu_eks.outputs.cluster_name,
        "--role-arn", data.terraform_remote_state.adu_eks.outputs.cluster_ae_role_arn
      ]
    }
  }
}

provider "kubernetes" {
  # Configuration options
  host                   = data.terraform_remote_state.adu_eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.adu_eks.outputs.cluster_certificate_authority)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.adu_eks.outputs.cluster_name,
      "--role-arn", data.terraform_remote_state.adu_eks.outputs.cluster_ae_role_arn
    ]
  }
}
