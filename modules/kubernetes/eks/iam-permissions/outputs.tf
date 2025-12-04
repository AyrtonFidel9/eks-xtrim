output "eks_cluster_iam_role_arn" {
  value = aws_iam_role.iam_eks_role.arn
}

output "eks_node_group_iam_role_arn" {
  value = aws_iam_role.afac_node_group_role.arn
}

output "eks_cluster_ae_role_arn" {
  value = aws_iam_role.afac_cluster_access_entry_role.arn
}