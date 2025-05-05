####################
# HVN
resource "hcp_hvn" "radar" {
  hvn_id         = "radar-hvn"
  cloud_provider = "aws"
  region         = "us-east-1"
  cidr_block     = "172.25.16.0/20"
}

# Dev Vault cluster
resource "hcp_vault_cluster" "radar" {
  cluster_id = "vault-radar"
  hvn_id     = hcp_hvn.radar.hvn_id
  tier       = "dev"
  project_id = data.hcp_project.radar.resource_id
  public_endpoint = true
}

resource "hcp_vault_cluster_admin_token" "radar" {
  cluster_id = hcp_vault_cluster.radar.cluster_id
}

provider "hcp" {
  client_id = "###"
  client_secret = "####"
}

# Existing HCP project
data "hcp_project" "radar" {
  project="22655e66-86e2-4697-b910-4944c23d4777"
}


