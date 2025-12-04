data "aws_iam_policy_document" "afac_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_eks_role" {
  name = "${var.tags.Application}-${var.environment.short}-eks-service-role"
  assume_role_policy = data.aws_iam_policy_document.afac_assume_role.json

  tags = merge({
    Name         = "${var.tags.Application}-${var.environment.short}-eks-service-role"
    CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    Environment  = var.environment.long
  }, var.tags)

  lifecycle { ignore_changes = [tags["CreationDate"]] }
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy"{
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.iam_eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-controller-policy"{
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role = aws_iam_role.iam_eks_role.name
}