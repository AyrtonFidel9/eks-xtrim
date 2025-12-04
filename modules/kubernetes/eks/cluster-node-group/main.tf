resource "time_static" "launch_template_creation" {}

resource "aws_launch_template" "eks_node_group_launch_template" {
  count = length(var.node_groups)

  name = "${var.node_groups[count.index].name}-launch-template"

  block_prodice_mappings {
    prodice_name = "/dev/xvda"
    ebs {
      volume_size           = var.node_groups[count.index].disk_size
      encrypted             = var.ebs_prodice_encrypted
      delete_on_termination = var.ebs_delete_on_termination
      volume_type           = var.ebs_volume_type
      throughput            = var.ebs_throughput
      kms_key_id            = var.ebs_kms_key_id
    }
  }

  ebs_optimized = var.ebs_optimized
  metadata_options {
    http_endpoint               = var.http_endpoint
    http_tokens                 = var.http_tokens
    http_put_response_hop_limit = var.http_put_response_hop_limit
    instance_metadata_tags      = var.instance_metadata_tags
  }

  vpc_security_group_ids = [var.nodegroup_sg_id]
  

  tag_specifications {
    resource_type = var.lt_tag_specifications_resource

    tags = merge({
        Name         = "${var.node_groups[count.index].name}-node"
        CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", time_static.launch_template_creation.rfc3339)
        Environment  = var.environment.long
      },
      var.tags,
      var.node_groups[count.index].custom_tags
    )
  }

  tags = merge({
    Name         = "${var.node_groups[count.index].name}-launch-template"
    Description  = "Launch tempalte to be used in ${var.node_groups[count.index].name} node group"
    CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    Environment  = var.environment.long
  }, var.tags)

  lifecycle { ignore_changes = [tags["CreationDate"]] }
}

resource "aws_eks_node_group" "eks_node_group" {
  count = length(var.node_groups)

  cluster_name    = var.cluster_name
  node_group_name = var.node_groups[count.index].name
  node_role_arn   = var.node_group_iam_role_arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.node_groups[count.index].instance_types
  capacity_type   = var.node_groups[count.index].capacity_type
  ami_type        = var.node_groups[count.index].ami_type
  release_version = var.node_groups[count.index].release_version

  launch_template {
    id      = aws_launch_template.eks_node_group_launch_template[count.index].id
    version = aws_launch_template.eks_node_group_launch_template[count.index].latest_version
  }

  scaling_config {
    desired_size = var.node_groups[count.index].scaling_desired_size
    max_size     = var.node_groups[count.index].scaling_max_size
    min_size     = var.node_groups[count.index].scaling_min_size
  }

  update_config {
    max_unavailable = var.node_groups[count.index].max_unavailable
  }

  dynamic "taint" {
    for_each = var.node_groups[count.index].taints
    content {
      key    = taint.value["key"]
      value  = taint.value["value"]
      effect = taint.value["effect"]
    }
  }

  tags = merge({
    Name         = "${var.node_groups[count.index].name}"
    CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    Environment  = var.environment.long
  }, var.tags)

  lifecycle { ignore_changes = [tags["CreationDate"]] }
}
