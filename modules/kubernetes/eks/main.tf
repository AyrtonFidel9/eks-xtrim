module "afac_eks_permissions" {
  source = "./iam-permissions"

  eks_iam_users_arn             = var.users_arn
  node_group_extra_policies_arn = var.node_group_extra_policies_arn
  environment                   = var.environment

  tags = {
    Description       = "eks iam roles and permissions"
    CreatedBy         = var.created_by
    Application       = var.application
    CostCenter        = var.cost_center
    Contact           = var.contact
    MaintenanceWindow = var.maintenance_window
    DeletionDate      = var.deletion_date
  }
}

module "afac_eks_security_groups" {
  source = "./security-groups"

  environment                = var.environment
  vpc_id                     = var.vpc_id
  additional_ingress         = var.additional_ingress_rules
  cluster_additional_ingress = var.cluster_additional_ingress
  tags = {
    CreatedBy         = var.created_by
    Application       = var.application
    CostCenter        = var.cost_center
    Contact           = var.contact
    MaintenanceWindow = var.maintenance_window
    DeletionDate      = var.deletion_date
  }
}

module "afac_eks_cluster" {
  source = "./cluster"

  eks_cluster_ae_role_arn         = module.afac_eks_permissions.eks_cluster_ae_role_arn
  eks_iam_role_arn                = module.afac_eks_permissions.eks_cluster_iam_role_arn
  subnet_ids                      = var.subnets_ids
  cluster_version                 = var.cluster_version
  cluster_sg_id                   = module.afac_eks_security_groups.cluster_security_group_id
  users_allowed_to_manage_kms     = var.users_allowed_to_manage_kms
  cluster_admin_users_permissions = var.cluster_admin_users_permissions
  endpoint_public_access          = var.endpoint_public_access

  environment = var.environment

  tags = {
    Description       = "EKS Cluster for ${var.application}"
    CreatedBy         = var.created_by
    Application       = var.application
    CostCenter        = var.cost_center
    Contact           = var.contact
    MaintenanceWindow = var.maintenance_window
    DeletionDate      = var.deletion_date
  }
}

module "afac_eks_node_groups" {
  source = "./cluster-node-group"

  cluster_name              = module.afac_eks_cluster.eks_cluster_name
  node_group_iam_role_arn   = module.afac_eks_permissions.eks_node_group_iam_role_arn
  node_groups               = var.node_groups
  subnet_ids                = var.subnets_ids
  environment               = var.environment
  cluster_security_group_id = module.afac_eks_cluster.cluster_security_group_id
  ebs_kms_key_id            = var.ebs_kms_key_id
  vpc_id                    = var.vpc_id
  nodegroup_sg_id           = module.afac_eks_security_groups.nodegroup_security_group_id
  cluster_version           = var.cluster_version

  tags = {
    Description       = "EKS node group for ${var.application}"
    CreatedBy         = var.created_by
    Application       = var.application
    CostCenter        = var.cost_center
    Contact           = var.contact
    MaintenanceWindow = var.maintenance_window
    DeletionDate      = var.deletion_date
  }
}

module "afac_eks_addons" {
  source = "./add-ons"

  cluster_name = module.afac_eks_cluster.eks_cluster_name
  addons       = var.addons
  openid_arn   = module.afac_eks_cluster.openid_arn
  openid_url   = module.afac_eks_cluster.openid_url

  environment = var.environment

  tags = {
    Description       = "EKS Add-ons for ${var.application}"
    CreatedBy         = var.created_by
    Application       = var.application
    CostCenter        = var.cost_center
    Contact           = var.contact
    MaintenanceWindow = var.maintenance_window
    DeletionDate      = var.deletion_date
  }

  depends_on = [module.afac_eks_node_groups, module.afac_eks_cluster]
}

module "afac_operators" {
  source = "./operators"

  cluster_name       = module.afac_eks_cluster.eks_cluster_name
  cluster_ca         = module.afac_eks_cluster.certificate_authority.0.data
  cluster_host       = module.afac_eks_cluster.endpoint
  cluser_ae_role_arn = module.afac_eks_permissions.eks_cluster_ae_role_arn
  vpc_id             = var.vpc_id
  cluster_oidc_id    = module.afac_eks_cluster.openid_oidc_id

  environment = var.environment
  tags = {
    Description       = "Kubernetes operator resource for ${var.application}"
    CreatedBy         = var.created_by
    Application       = var.application
    CostCenter        = var.cost_center
    Contact           = var.contact
    MaintenanceWindow = var.maintenance_window
    DeletionDate      = var.deletion_date
  }

  node_groups_dep = module.afac_eks_node_groups.node_groups_names # Variable used to generate a dependency of Node Groups Creation
}
