###########################
# Service principal secrets
###########################

output "hcp_client_id" {
  value     = hcp_service_principal_key.key.client_id
  sensitive = true
}

output "hcp_client_secret" {
  value     = hcp_service_principal_key.key.client_secret
  sensitive = true
}


###########################
# Vault cluster details
###########################
output "cluster_endpoint" {
  value = hcp_vault_cluster.radar.vault_public_endpoint_url
}

output "cluster_endpoint_no_protocol" {
  value = replace(hcp_vault_cluster.radar.vault_public_endpoint_url, "https://", "")
}


###########################
# Vault cataloging details
###########################

output "auth_method"{
  value = "AppRole(Push)"
}
output "auth_path"{
  value = vault_approle_auth_backend_role.radar.id
}

output "auth_role_id_env"{
  value = "env://ROLE_ID"
}

output "auth_secret_id_env"{
  value = "env://SECRET_ID"
}

output "vault_agent_run_instructions" {
  value = "Execute vault-radar agent exec"
}

output "vault_role_id" {
  value = vault_approle_auth_backend_role.radar.role_id
}

output "vault_secret_id" {
  value = vault_approle_auth_backend_role_secret_id.radar.secret_id
  sensitive = true
}