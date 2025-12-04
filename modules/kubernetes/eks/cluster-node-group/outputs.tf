output "node_groups_names" {
  value = aws_eks_node_group.eks_node_group.*.node_group_name
}

output "autoscaling_group_names" {
  value = flatten(aws_eks_node_group.eks_node_group[*].resources[*].autoscaling_groups[*].name)
}