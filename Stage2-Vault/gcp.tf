resource "vault_gcp_secret_backend" "gcp" {
  credentials               = file("creds/vault-secret-gcp.json")
  path = "gcp-demo"
  description               = "Demo GCP Backend"
  default_lease_ttl_seconds = "300"
  max_lease_ttl_seconds     = "3600"
}

resource "vault_gcp_secret_roleset" "demo" {
  backend      = vault_gcp_secret_backend.gcp.path
  roleset      = "demo-nov-2023"
  secret_type  = "service_account_key"
  project      = "hug-sas-341"
  token_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

  binding {
    resource = "//cloudresourcemanager.googleapis.com/projects/main-341"

    roles = [
      "roles/editor"
    ]
  }

}
