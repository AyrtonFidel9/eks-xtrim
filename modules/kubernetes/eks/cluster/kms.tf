resource "aws_kms_key" "eks_key" {
  description             = "Symmetric encryption KMS key for eks cluster"
  enable_key_rotation     = true
  deletion_window_in_days = 20
  multi_region            = true
}

resource "aws_kms_alias" "eks_key" {
  name          = "alias/afac/xtrim/eks-key"
  target_key_id = aws_kms_key.eks_key.key_id
}

resource "aws_kms_key_policy" "eks" {
  key_id = aws_kms_key.eks_key.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "KeyAdministration"
        Effect = "Allow"
        Principal = {
          AWS = var.users_allowed_to_manage_kms
        }
        Action = [
          "kms:Update*",
          "kms:UntagResource",
          "kms:TagResource",
          "kms:ScheduleKeyDeletion",
          "kms:Revoke*",
          "kms:Put*",
          "kms:List*",
          "kms:Get*",
          "kms:Enable*",
          "kms:Disable*",
          "kms:Describe*",
          "kms:Delete*",
          "kms:Create*",
          "kms:CancelKeyDeletion"
        ]
        Resource = "*"
      },
      {
        Sid = "KeyUsage"
        Effect = "Allow"
        Principal = {
          AWS = var.eks_iam_role_arn
        }
        Action = [
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Encrypt",
          "kms:DescribeKey",
          "kms:Decrypt"
        ]
        Resource = "*"
      },
      {
        Sid = "AllowRootAccountAdministration"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "kms:*"
        Resource = "*"
      },
    ]
  })
}
