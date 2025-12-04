resource "aws_iam_role" "external_dns" {
  name               = "${var.tags.Application}-${var.env.short}-external-dns-service-account-role"
  assume_role_policy = data.aws_iam_policy_document.external_dns_assume_role.json

  tags = {
    Name         = "${var.tags.Application}-${var.env.short}-external-dns-service-account-account-role"
    CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    Environment  = var.env.long
  }

  lifecycle { ignore_changes = [tags["CreationDate"]] }
}

resource "aws_iam_policy" "external_dns" {
  name   = "${var.tags.Application}-${var.env.short}-external-dns-service-account"
  policy = data.aws_iam_policy_document.external_dns.json

  tags = {
    CreationDate = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    Environment  = var.env.long
  }

  lifecycle { ignore_changes = [tags["CreationDate"]] }
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  policy_arn = aws_iam_policy.external_dns.arn
  role       = aws_iam_role.external_dns.name
}