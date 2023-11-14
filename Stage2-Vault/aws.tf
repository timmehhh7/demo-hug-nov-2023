resource "vault_aws_secret_backend" "aws" {
  path                      = "aws-demo"
  description               = "Demo AWS Backend"
  access_key                = var.AWS_ACCESS_KEY_ID
  secret_key                = var.AWS_SECRET_ACCESS_KEY
  default_lease_ttl_seconds = "300"
  max_lease_ttl_seconds     = "900"
}

resource "vault_aws_secret_backend_role" "role" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "demo-nov-2023"
  credential_type = "iam_user"
  policy_arns     = ["arn:aws:iam::aws:policy/PowerUserAccess"]
  policy_document = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "NotAction": [
                "iam:*",
                "organizations:*",
                "account:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole",
                "iam:DeleteServiceLinkedRole",
                "iam:ListRoles",
                "iam:GetUser",
                "organizations:DescribeOrganization",
                "account:ListRegions",
                "account:GetAccountInformation"
            ],
            "Resource": "*"
        }
    ]
}
EOT
}