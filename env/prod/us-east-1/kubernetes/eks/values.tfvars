node_groups = [
  {
    name                 = "core",
    instance_types       = ["t3a.medium"],
    capacity_type        = "ON_DEMAND",
    ami_type             = "AL2023_x86_64_STANDARD",
    disk_size            = 20, # minimum accepted by EKs
    scaling_desired_size = 3,
    scaling_max_size     = 3,
    scaling_min_size     = 1,
    max_unavailable      = 1,
    taints               = [],
    release_version      = "1.34.1-20251112"
    custom_tags = {
      "aws-node-termination-handler/managed" = "true"
    }
  },
  {
    name                 = "monitoring",
    instance_types       = ["t3a.medium"],
    capacity_type        = "ON_DEMAND",
    ami_type             = "AL2023_x86_64_STANDARD",
    disk_size            = 20, # minimum accepted by EKs
    scaling_desired_size = 3,
    scaling_max_size     = 3,
    scaling_min_size     = 1,
    max_unavailable      = 1,
    taints = [
      {
        key    = "workload",
        value  = "monitoring",
        effect = "NO_SCHEDULE"
      }
    ],
    release_version = "1.34.1-20251112"
    custom_tags = {
      "aws-node-termination-handler/managed" = "true"
    }
  }
]

node_group_extra_policies_arn = [
  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation",
  "arn:aws:iam::aws:policy/AWSQuickSetupPatchPolicyBaselineAccess"
]

users_arn = [

]

cluster_admin_users_permissions = [
]

users_allowed_to_manage_kms = [

]

cluster_version = "1.34"

addons = [
  {
    name              = "vpc-cni",
    version           = "v1.20.4-eksbuild.1",
    resolve_conflicts = "OVERWRITE"
  },
  {
    name              = "coredns",
    version           = "v1.12.4-eksbuild.1",
    resolve_conflicts = "OVERWRITE"
  },
  {
    name              = "kube-proxy",
    version           = "v1.34.0-eksbuild.4",
    resolve_conflicts = "OVERWRITE"
  },
  {
    name              = "aws-ebs-csi-driver",
    version           = "v1.49.0-eksbuild.1",
    resolve_conflicts = "OVERWRITE"
  },
  {
    name              = "aws-efs-csi-driver",
    version           = "v2.1.12-eksbuild.1",
    resolve_conflicts = "OVERWRITE"
  },
  {
    name              = "eks-pod-identity-agent"
    version           = "v1.3.9-eksbuild.5"
    resolve_conflicts = "OVERWRITE"
  }
]

endpoint_public_access = false

created_by         = "Ayrton Fidel"
application        = "xtrim"
cost_center        = "ND"
contact            = "ayrton.avalos@workersbenefitfund.com"
maintenance_window = "ND"
deletion_date      = "ND"
