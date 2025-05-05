########################
# HCP Service principal

resource "hcp_service_principal" "this" {
  name = "radar"
  parent = data.hcp_project.radar.resource_name
}

resource "hcp_project_iam_binding" "example" {
  project_id   = data.hcp_project.radar.resource_id
  principal_id = hcp_service_principal.this.resource_id
  role         = "roles/admin" # Doesn't support the Vault radar service role yet
}

resource "hcp_service_principal_key" "key" {
  service_principal = hcp_service_principal.this.resource_name
}


