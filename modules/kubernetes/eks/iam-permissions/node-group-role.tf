resource "aws_iam_role" "afac_node_group_role" {
  name = "${var.tags.Application}-${var.environment.short}-node-group-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = merge({
    Name         = "${var.tags.Application}-${var.environment.short}-node-group-role"
    CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    Environment  = var.environment.long
  }, var.tags)

  lifecycle { ignore_changes = [tags["CreationDate"]] }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.afac_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.afac_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.afac_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_group_extra_policies_arn" {
  count      = length(var.node_group_extra_policies_arn)
  policy_arn = var.node_group_extra_policies_arn[count.index]
  role       = aws_iam_role.afac_node_group_role.name
}

