resource "aws_iam_role" "afac_cluster_access_entry_role" {
  name = "${var.tags.Application}-${var.environment.short}-eks-cluster-access-entry-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        AWS = var.eks_iam_users_arn
      }
    }]
    Version = "2012-10-17"
  })
  
  tags = merge({
    Name         = "${var.tags.Application}-${var.environment.short}-eks-cluster-access-entry-role"
    CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    Environment  = var.environment.long
  }, var.tags)

  lifecycle { ignore_changes = [tags["CreationDate"]] }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicyClusterIamRole" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.afac_cluster_access_entry_role.name
}