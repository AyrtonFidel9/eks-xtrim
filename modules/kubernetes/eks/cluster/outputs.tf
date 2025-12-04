output "eks_cluster_id" {
  value = aws_eks_cluster.afac_eks_cluster.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.afac_eks_cluster.name
}

output "certificate_authority" {
  value = aws_eks_cluster.afac_eks_cluster.certificate_authority
}

output "endpoint" {
  value = aws_eks_cluster.afac_eks_cluster.endpoint
}

output "openid_arn" {
  value = aws_iam_openid_connect_provider.eks_oidc.arn
}

output "openid_oidc_id" {
  value = element(
    split("/", aws_iam_openid_connect_provider.eks_oidc.arn),
    length(split("/", aws_iam_openid_connect_provider.eks_oidc.arn)) - 1
  )
}

output "openid_url" {
  value = aws_iam_openid_connect_provider.eks_oidc.url
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.afac_eks_cluster.vpc_config[0].cluster_security_group_id
}