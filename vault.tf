provider "vault" {
  address = hcp_vault_cluster.radar.vault_public_endpoint_url
  token   = hcp_vault_cluster_admin_token.radar.token
}

# Enable app role
resource "vault_auth_backend" "approle" {
  type = "approle"
}

## Based on vault app role policy

data "vault_policy_document" "radar_policy" {
  rule {
    path         = "auth/token/lookup-self"
    capabilities = ["read"]
  }
  rule {
    path         = "sys/namespaces/*"
    capabilities = ["read", "list"]
  }
  rule {
    path         = "+/sys/namespaces/*"
    capabilities = ["read", "list"]
  }

  rule {
    path         = "+/+/sys/namespaces/*"
    capabilities = ["read", "list"]
  }

  rule {
    path         = "sys/auth"
    capabilities = ["read"]
  }

  rule {
    path         = "+/sys/auth"
    capabilities = ["read"]
  }

  rule {
    path         = "+/+/sys/auth"
    capabilities = ["read"]
  }

  rule {
    path         = "sys/mounts"
    capabilities = ["read"]
  }

  rule {
    path         = "+/sys/mounts"
    capabilities = ["read"]
  }

  rule {
    path         = "+/+/sys/mounts"
    capabilities = ["read"]
  }

  rule {
    path         = "+/metadata/*"
    capabilities = ["read", "list"]
  }

  rule {
    path         = "+/+/metadata/*"
    capabilities = ["read", "list"]
  }

  rule {
    path         = "+/+/+/metadata/*"
    capabilities = ["read", "list"]
  }

  rule {
    path         = "+/+/+/+/metadata/*"
    capabilities = ["read", "list"]
  }

  rule {
    path         = "+/data/*"
    capabilities = ["read"]
  }

  rule {
    path         = "+/+/data/*"
    capabilities = ["read"]
  }

  rule {
    path         = "+/+/+/data/*"
    capabilities = ["read"]
  }

  rule {
    path         = "+/+/+/+/data/*"
    capabilities = ["read"]
  }

  rule {
    path         = "*"
    capabilities = ["read", "list"]
  }

  rule {
    path         = "secret/+/*"
    capabilities = ["create", "read", "list", "patch", "update"]
  }
}
resource "vault_policy" "radar" {
  name   = "radar"
  policy = data.vault_policy_document.radar_policy.hcl
}

## Create an app role to use
resource "vault_approle_auth_backend_role" "radar" {
  backend        = vault_auth_backend.approle.path
  role_name      = "radar"
  bind_secret_id = true

  token_policies = [vault_policy.radar.name]
}


resource "vault_approle_auth_backend_role_secret_id" "radar" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.radar.role_name
}

### Enabling KV V2 secret engine

resource "vault_mount" "kvv2" {
  path        = "kvv2"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_backend_v2" "example" {
  mount                = vault_mount.kvv2.path
  max_versions         = 5
  delete_version_after = 12600
  cas_required         = true
}

resource "terraform_data" "local_export" {

  provisioner "local-exec" {
    environment = {
      PROJECT_ID         = data.hcp_project.radar.resource_id
      AGENT_POOL_ID      = var.agent_pool_id
      CLIENT_ID          = hcp_service_principal_key.key.client_id
      CLIENT_SECRET      = hcp_service_principal_key.key.client_secret
      APP_ROLE_ID        = vault_approle_auth_backend_role.radar.role_id
      APP_ROLE_SECRET_ID = vault_approle_auth_backend_role_secret_id.radar.secret_id
    }
    command = join("&&", ["export HCP_PROJECT_ID=$PROJECT_ID",
      "export HCP_RADAR_AGENT_POOL_ID=$AGENT_POOL_ID",
      "export HCP_CLIENT_ID=$CLIENT_ID",
      "export HCP_CLIENT_SECRET=$CLIENT_SECRET",
      "export ROLE_ID=$APP_ROLE_ID",
      "export SECRET_ID=$APP_ROLE_SECRET_ID"]
    )
  }
}


### No agent pool id resource for Vault Radar in the HCP provider.
variable "agent_pool_id" {
  type    = string
  default = "###"
}
