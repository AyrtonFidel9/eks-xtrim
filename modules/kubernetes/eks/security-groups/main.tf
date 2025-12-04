resource "aws_security_group" "eks_cluster_sg" {
  name = "${local.cluster_name}-master-node-security-group"

  description = "Security Group for ${local.cluster_name} master node"

  vpc_id = var.vpc_id

  tags = merge({
    Name         = "${local.cluster_name}-master-node-security-group"
    CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    Environment  = var.environment.long
    Description  = "Security Group for ${local.cluster_name} worker nodes groups"
  }, var.tags)

  lifecycle { ignore_changes = [tags["CreationDate"]] }
}

# Allow all IPv4 outbound
resource "aws_vpc_security_group_egress_rule" "eks_cluster_sg_all_ipv4" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all IPv4 traffic"
}

# Allow all traffic to itself
resource "aws_vpc_security_group_egress_rule" "eks_cluster_sg_self" {
  security_group_id            = aws_security_group.eks_cluster_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.eks_cluster_sg.id
  description                  = "Allow all traffic to self"
}

resource "aws_vpc_security_group_ingress_rule" "eks_cluster_sg_self" {
  security_group_id            = aws_security_group.eks_cluster_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.eks_cluster_sg.id
  description                  = "Allow all traffic from self"
}

resource "aws_vpc_security_group_ingress_rule" "eks_cluster_sg_additional" {
  for_each = {
    for idx, rule in var.cluster_additional_ingress : "${idx}-${rule.from_port}-${rule.to_port}" => rule
  }

  security_group_id = aws_security_group.eks_cluster_sg.id 
  from_port         = each.value.from_port != 0 ? each.value.from_port : null
  to_port           = each.value.to_port != 0 ? each.value.to_port : null
  ip_protocol       = each.value.protocol

  # Conditional source handling
  cidr_ipv4                    = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+", each.value.source)) ? each.value.source : null
  cidr_ipv6                    = can(regex(":", each.value.source)) ? each.value.source : null
  referenced_security_group_id = can(regex("^sg-", each.value.source)) ? each.value.source : null
  description                  = each.value.description
}

resource "aws_security_group" "eks_node_group_sg" {
  name = "${local.cluster_name}-worker-nodes-security-group"

  description = "Security Group for ${local.cluster_name} worker nodes groups"

  vpc_id = var.vpc_id

  tags = merge({
    Name         = "${local.cluster_name}-worker-nodes-security-group"
    CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    Environment  = var.environment.long
    Description  = "Security Group for ${local.cluster_name} worker nodes groups"
  }, var.tags)

  lifecycle { ignore_changes = [tags["CreationDate"]] }
}

# Allow all IPv4 outbound
resource "aws_vpc_security_group_egress_rule" "eks_node_group_sg_all_ipv4" {
  security_group_id = aws_security_group.eks_node_group_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all IPv4 traffic"
}

resource "aws_vpc_security_group_ingress_rule" "eks_node_group_sg_self" {
  security_group_id            = aws_security_group.eks_node_group_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.eks_node_group_sg.id
  description                  = "Allow all traffic from self"
}

resource "aws_vpc_security_group_ingress_rule" "eks_node_group_sg_additional" {
  for_each = {
    for idx, rule in var.cluster_additional_ingress : "${idx}-${rule.from_port}-${rule.to_port}" => rule
  }

  security_group_id = aws_security_group.eks_node_group_sg.id
  from_port         = each.value.from_port != 0 ? each.value.from_port : null
  to_port           = each.value.to_port  != 0 ? each.value.to_port : null
  ip_protocol       = each.value.protocol

  # Conditional source handling
  cidr_ipv4                    = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+", each.value.source)) ? each.value.source : null
  cidr_ipv6                    = can(regex(":", each.value.source)) ? each.value.source : null
  referenced_security_group_id = can(regex("^sg-", each.value.source)) ? each.value.source : null
  description                  = each.value.description
}

# Ingress rules
resource "aws_vpc_security_group_ingress_rule" "eks_node_group_sg_from_cluster" {
  security_group_id            = aws_security_group.eks_node_group_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.eks_cluster_sg.id
  description                  = "Allow all traffic from control plane"
  depends_on                   = [aws_security_group.eks_cluster_sg, aws_security_group.eks_node_group_sg]
}

# Ingress rules
resource "aws_vpc_security_group_ingress_rule" "eks_cluster_sg_from_nodes" {
  security_group_id            = aws_security_group.eks_cluster_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.eks_node_group_sg.id
  description                  = "Allow all traffic from worker nodes"
  depends_on                   = [aws_security_group.eks_cluster_sg, aws_security_group.eks_node_group_sg]
}

