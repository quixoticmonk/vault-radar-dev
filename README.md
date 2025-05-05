<!-- BEGIN_TF_DOCS -->
# Vault Radar Infrastructure

This directory contains the Terraform configuration for setting up the HCP Vault Radar infrastructure. The infrastructure includes an HCP Vault cluster, service principals, authentication methods, and secret engines required for Vault Radar to function.

> [!NOTE]
> Few of the crucial steps in the HCP Vault Radar setup is currently manual as the HCP API reference documentation doesn't include any path to do so and hence the hcp provider doesn't support Vault Radar outside of the notification integrations.
> </br> 1. Connecting an Existing Secrets Manager ( Vault)
> </br> 2. Creating a Vault Radar agent pool
> </br> 3. Creating a Remediation action with the associated secrets manager

## Components

### HCP Vault Cluster

The infrastructure provisions a development tier HCP Vault cluster in AWS:

- **HVN (HashiCorp Virtual Network)**: A dedicated network for the Vault cluster in AWS us-east-1 region
- **Vault Cluster**: A development tier Vault cluster with public endpoint enabled
- **Admin Token**: Generated for initial configuration and management

### Service Principal

A service principal is created for Vault Radar with admin permissions:

- **Service Principal**: Named "radar" with admin role binding
- **Service Principal Key**: Generated for authentication

### Vault Configuration

The following Vault resources are configured:

- **Auth Method**: AppRole authentication backend for Vault Radar
- **Policy**: A comprehensive policy document that grants Vault Radar the necessary permissions to:
  - Read token information
  - List and read namespaces
  - Read auth methods
  - Read mount points
  - Read and list KV metadata
  - Read KV data
- **KV Secret Engine**: Version 2 KV secret engine mounted at "kvv2" path

### Environment Setup

The configuration includes a local-exec provisioner that exports the necessary environment variables for Vault Radar:

- HCP\_PROJECT\_ID
- HCP\_RADAR\_AGENT\_POOL\_ID
- HCP\_CLIENT\_ID
- HCP\_CLIENT\_SECRET
- ROLE\_ID (AppRole role ID)
- SECRET\_ID (AppRole secret ID)

## Resource Mapping

The `resource-to-secret-manager-mapping.csv` file maps Git repositories to Vault secret paths, allowing Vault Radar to scan repositories and identify secrets that should be stored in Vault.

## Outputs

The configuration provides several outputs:

- **Service Principal Credentials**: Client ID and secret for HCP authentication
- **Vault Cluster Details**: Endpoint URL (with and without protocol)
- **Vault Cataloging Details**: Authentication method, path, and credentials
- **Vault Agent Instructions**: Command to run the Vault Radar agent

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Apply the configuration:
   ```
   terraform apply
   ```

3. Use the outputs to configure Vault Radar:
   ```
   terraform output -json
   ```

## Security Note

The configuration includes sensitive information like tokens and credentials. Ensure these are properly secured and not committed to version control.

## Prerequisites

- HCP account with appropriate permissions
- AWS account (for HVN)
- Terraform installed locally

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | 0.105.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [hcp_hvn.radar](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/hvn) | resource |
| [hcp_project_iam_binding.example](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/project_iam_binding) | resource |
| [hcp_service_principal.this](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/service_principal) | resource |
| [hcp_service_principal_key.key](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/service_principal_key) | resource |
| [hcp_vault_cluster.radar](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/vault_cluster) | resource |
| [hcp_vault_cluster_admin_token.radar](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/vault_cluster_admin_token) | resource |
| [terraform_data.local_export](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [vault_approle_auth_backend_role.radar](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/approle_auth_backend_role) | resource |
| [vault_approle_auth_backend_role_secret_id.radar](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/approle_auth_backend_role_secret_id) | resource |
| [vault_auth_backend.approle](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend) | resource |
| [vault_kv_secret_backend_v2.example](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_backend_v2) | resource |
| [vault_mount.kvv2](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |
| [vault_policy.radar](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [hcp_project.radar](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/project) | data source |
| [vault_policy_document.radar_policy](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_pool_id"></a> [agent\_pool\_id](#input\_agent\_pool\_id) | n/a | `string` | `"2730b2f4-0eec-465b-b0bf-9e476eabe2d2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auth_method"></a> [auth\_method](#output\_auth\_method) | n/a |
| <a name="output_auth_path"></a> [auth\_path](#output\_auth\_path) | n/a |
| <a name="output_auth_role_id_env"></a> [auth\_role\_id\_env](#output\_auth\_role\_id\_env) | n/a |
| <a name="output_auth_secret_id_env"></a> [auth\_secret\_id\_env](#output\_auth\_secret\_id\_env) | n/a |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | ########################## Vault cluster details ########################## |
| <a name="output_cluster_endpoint_no_protocol"></a> [cluster\_endpoint\_no\_protocol](#output\_cluster\_endpoint\_no\_protocol) | n/a |
| <a name="output_hcp_client_id"></a> [hcp\_client\_id](#output\_hcp\_client\_id) | n/a |
| <a name="output_hcp_client_secret"></a> [hcp\_client\_secret](#output\_hcp\_client\_secret) | n/a |
| <a name="output_vault_agent_run_instructions"></a> [vault\_agent\_run\_instructions](#output\_vault\_agent\_run\_instructions) | n/a |
| <a name="output_vault_role_id"></a> [vault\_role\_id](#output\_vault\_role\_id) | n/a |
| <a name="output_vault_secret_id"></a> [vault\_secret\_id](#output\_vault\_secret\_id) | n/a |
<!-- END_TF_DOCS -->