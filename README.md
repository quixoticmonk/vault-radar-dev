# Vault Radar Infrastructure

This directory contains the Terraform configuration for setting up the HCP Vault Radar infrastructure. The infrastructure includes an HCP Vault cluster, service principals, authentication methods, and secret engines required for Vault Radar to function and allow a remediation action to copy discovered secrets to Vault.

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

- HCP_PROJECT_ID
- HCP_RADAR_AGENT_POOL_ID
- HCP_CLIENT_ID
- HCP_CLIENT_SECRET
- ROLE_ID (AppRole role ID)
- SECRET_ID (AppRole secret ID)

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

- HCP account with appropriate permissions ( provider details are masked in configuration)
- Terraform installed locally
- Vault radar CLI installed locally
- Vault CLI installed locally, if you need to debug.
