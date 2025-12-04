output "nodegroup_security_group_id" {
  value = aws_security_group.eks_node_group_sg.id
}

output "cluster_security_group_id" {
  value = aws_security_group.eks_cluster_sg.id
}