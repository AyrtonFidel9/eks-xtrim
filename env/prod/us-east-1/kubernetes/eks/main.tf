module "xtrim-eks-cluster" {
  source  = "/Users/fidel/Documents/afac/xtrim/eks-xtrim/modules/kubernetes/eks"

  users_arn                       = var.users_arn
  cluster_version                 = var.cluster_version
  addons                          = var.addons
  node_group_extra_policies_arn   = var.node_group_extra_policies_arn
  subnets_ids                     = toset([for rt in data.terraform_remote_state.xtrim_network.outputs.subnets : rt.id if rt.tags["SubnetType"] == "private"])
  node_groups                     = var.node_groups
  vpc_id                          = data.terraform_remote_state.xtrim_network.outputs.vpc_id
  ebs_kms_key_id                  = data.aws_kms_key.ebs_by_id.arn
  users_allowed_to_manage_kms     = var.users_allowed_to_manage_kms
  cluster_admin_users_permissions = var.cluster_admin_users_permissions
  additional_ingress_rules = [

  ]

  cluster_additional_ingress = [

  ]

  endpoint_public_access = var.endpoint_public_access

  environment        = var.env
  created_by         = var.created_by
  application        = var.application
  cost_center        = var.cost_center
  contact            = var.contact
  maintenance_window = var.maintenance_window
  deletion_date      = var.deletion_date
}