output "cluster_name" {
  value = module.xtrim-eks-cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.xtrim-eks-cluster.cluster_endpoint
}

output "cluster_ae_role_arn" {
  value = module.xtrim-eks-cluster.cluster_ae_role_arn
}

output "cluster_certificate_authority" {
  value     = module.xtrim-eks-cluster.cluster_certificate_authority
  sensitive = true
}

output "cluster_id" {
  value = module.xtrim-eks-cluster.cluster_id
}

output "cluster_oidc_id" {
  value = module.xtrim-eks-cluster.cluster_oidc_id
}

output "autoscaling_node_group_names" {
  value = module.xtrim-eks-cluster.autoscaling_node_group_names
}

output "nodes_secutity_group_id" {
  value = module.xtrim-eks-cluster.nodes_security_group_id
}