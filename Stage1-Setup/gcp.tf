resource "random_integer" "project_number" {
  min = 100
  max = 500
}

data "google_organization" "org" {
  domain = var.gcp_org
}

module "demo-nov-2023_folder" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric.git//modules/folder?ref=v24.0.0"

  parent = data.google_organization.org.name
  name   = "demo-nov-2023"
  org_policies = {
    "iam.disableServiceAccountKeyCreation" = {
      rules = [{ enforce = true }]
    }
    "iam.disableServiceAccountKeyUpload" = {
      rules = [{ enforce = true }]
    }
  }
}

module "main_project" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric.git//modules/project?ref=v24.0.0"

  billing_account     = var.gcp_billing_account_id
  name                = "main-${random_integer.project_number.result}"
  parent              = module.demo-nov-2023_folder.folder.id
  services            = var.enabled_services
  auto_create_network = true
}

module "service_accounts_project" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric.git//modules/project?ref=v24.0.0"

  billing_account     = var.gcp_billing_account_id
  name                = "hug-sas-${random_integer.project_number.result}"
  parent              = data.google_organization.org.name
  services            = var.enabled_services
  auto_create_network = true
  org_policies = {
    "iam.disableServiceAccountKeyCreation" = {
      rules = [{ enforce = false }]
    }
  }
}
