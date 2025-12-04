data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "terraform_remote_state" "adu_eks" {
  backend = "s3"
  config = {
    bucket = "adu-infrastructure-us-east-1-dev"
    key    = "env/dev/us-east-1/kubernetes/eks/terraform.tfstate"
    region = "us-east-1"
  }
}


data "aws_iam_policy_document" "external_dns_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${data.aws_region.current.id}.amazonaws.com/id/${data.terraform_remote_state.adu_eks.outputs.cluster_oidc_id}"
      ]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "oidc.eks.${data.aws_region.current.id}.amazonaws.com/id/${data.terraform_remote_state.adu_eks.outputs.cluster_oidc_id}:sub"
      values = [
        "system:serviceaccount:kube-system:external-dns-sa"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "oidc.eks.${data.aws_region.current.id}.amazonaws.com/id/${data.terraform_remote_state.adu_eks.outputs.cluster_oidc_id}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "external_dns" {
  statement {
    sid    = "ExternalDnsOperatorSa"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets"
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*"
    ]
  }

  statement {
    sid    = "ExternalDnsOperatorSa2"
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResources"
    ]

    resources = [
      "*"
    ]
  }
}
