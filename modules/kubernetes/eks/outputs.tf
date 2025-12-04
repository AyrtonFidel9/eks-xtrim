output "cluster_name" {
  value = module.afac_eks_cluster.eks_cluster_name
}

output "cluster_endpoint" {
  value = module.afac_eks_cluster.endpoint
}

output "cluster_ae_role_arn" {
  value = module.afac_eks_permissions.eks_cluster_ae_role_arn
}

output "cluster_certificate_authority" {
  value = module.afac_eks_cluster.certificate_authority.0.data
}

output "cluster_id" {
  value = module.afac_eks_cluster.eks_cluster_id
}

output "cluster_oidc_id" {
  value = module.afac_eks_cluster.openid_oidc_id
}

output "autoscaling_node_group_names" {
  value = module.afac_eks_node_groups.autoscaling_group_names
}

output "nodes_security_group_id" {
  value = module.afac_eks_security_groups.nodegroup_security_group_id
}

output "cluster_security_group_id" {
  value = module.afac_eks_security_groups.cluster_security_group_id
}