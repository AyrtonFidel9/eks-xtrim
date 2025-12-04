resource "aws_eks_cluster" "afac_eks_cluster" {
  name                      = "${var.tags.Application}-${var.environment.short}-eks-cluster"
  role_arn                  = var.eks_iam_role_arn
  enabled_cluster_log_types = var.cluster_logs
  version                   = var.cluster_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = !var.endpoint_public_access
    security_group_ids      = [var.cluster_sg_id]
  }

  access_config {
    authentication_mode                         = var.auth_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_key.arn
    }
    resources = ["secrets"]
  }

  tags = merge(
    {
      Name         = "${var.tags.Application}-${var.environment.short}-eks-cluster"
      CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
      Environment  = var.environment.long
    },
    var.tags
  )

  lifecycle { ignore_changes = [tags["CreationDate"]] }
}

resource "aws_cloudwatch_log_group" "eks_cluster_logs" {
  name              = "/aws/eks/${"${var.tags.Application}-${var.environment.short}-eks-cluster"}/cluster"
  retention_in_days = 7

  tags = merge(
    {
      CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
      Environment  = var.environment.long
    },
    var.tags
  )

  lifecycle { ignore_changes = [tags["CreationDate"]] }
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.aws_eks_tls.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.aws_eks_tls.url
}

resource "aws_iam_role" "oidc_eks_role" {
  assume_role_policy = data.aws_iam_policy_document.eks_oidc_assume_role_policy.json
  name               = "${var.environment.short}-${var.tags.Application}-eks-cluster-service-role"

  tags = merge({
    CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
  }, var.tags)

  lifecycle { ignore_changes = [tags["CreationDate"]] }
}

resource "aws_eks_access_entry" "custom_access_entry" {
  cluster_name  = aws_eks_cluster.afac_eks_cluster.name
  principal_arn = var.eks_cluster_ae_role_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "AmazonEKSClusterAdminPolicyAssociation" {
  cluster_name  = aws_eks_cluster.afac_eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.eks_cluster_ae_role_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_entry" "admin_users_access_entry" {
  count = length(var.cluster_admin_users_permissions)

  cluster_name  = aws_eks_cluster.afac_eks_cluster.name
  principal_arn = var.cluster_admin_users_permissions[count.index]
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin_users_access_entry_AmazonEKSClusterAdminPolicyAssociation" {
  count         = length(var.cluster_admin_users_permissions)
  cluster_name  = aws_eks_cluster.afac_eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.cluster_admin_users_permissions[count.index]

  access_scope {
    type = "cluster"
  }
}
