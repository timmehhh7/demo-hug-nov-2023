resource "random_string" "user" {
  length  = 6
  special = false
}

data "aws_organizations_organization" "root" {}

resource "aws_organizations_organizational_unit" "demo-nov-2023" {
  name      = "demo-nov-2023"
  parent_id = data.aws_organizations_organization.root.roots[0].id
}

resource "aws_organizations_account" "demo" {
  name              = "main"
  email             = "ca_labadmins+main-${random_string.user.result}@${var.mailbox_domain}"
  role_name         = "Administrator"
  parent_id         = aws_organizations_organizational_unit.demo-nov-2023.id
  close_on_deletion = true
  lifecycle {
    ignore_changes = [role_name, email]
  }
}
