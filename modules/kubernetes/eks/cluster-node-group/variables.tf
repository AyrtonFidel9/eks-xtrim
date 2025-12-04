variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "node_group_iam_role_arn" {
  type = string
}

variable "node_groups" {
  type = list(object({
    name                 = string
    instance_types       = list(string)
    capacity_type        = string
    ami_type             = string
    disk_size            = number
    scaling_desired_size = number
    scaling_max_size     = number
    scaling_min_size     = number
    max_unavailable      = number
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
    release_version = string
    custom_tags     = map(string)
  }))
}

variable "nodegroup_sg_id" {
  type = string
}

variable "ebs_prodice_encrypted" {
  type    = bool
  default = true
}

variable "ebs_delete_on_termination" {
  type    = bool
  default = true
}

variable "ebs_optimized" {
  type    = bool
  default = true
}

variable "ebs_volume_type" {
  type    = string
  default = "gp3"
}

variable "ebs_throughput" {
  type    = number
  default = 300
}

variable "ebs_kms_key_id" {
  type = string
}

variable "http_endpoint" {
  description = "Whether the EC2 instance metadata service is available."
  type        = string
  default     = "enabled"
}

variable "http_tokens" {
  description = "Whether session tokens are required (IMDSv2)."
  type        = string
  default     = "required"
}

variable "http_put_response_hop_limit" {
  description = "The desired HTTP PUT response hop limit for instance metadata requests."
  type        = number
  default     = 1
}

variable "instance_metadata_tags" {
  description = "Whether the instance metadata service is available to retrieve instance tags."
  type        = string
  default     = "enabled"
}

variable "lt_tag_specifications_resource" {
  type    = string
  default = "instance"
}


variable "vpc_id" {
  type = string
}

variable "cluster_security_group_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "environment" {
  type = object({
    long  = string
    short = string
  })
}


variable "tags" {
  description = "tags for resources"
  type = object({
    Description       = string
    CreatedBy         = string
    Application       = string
    CostCenter        = string
    Contact           = string
    MaintenanceWindow = string
    DeletionDate      = string
  })
}
