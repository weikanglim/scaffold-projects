
# Next Steps

## 1. Define environment variables for running services

Modify or add environment variables to configure the running application. Environment variables can be configured by modifying the `env` node in the following files:

- [app/api-simple.bicep](./infra/app/api-simple.bicep)

To define a secret as an environment variable, the secret can first be stored in KeyVault.

## 2. Provision infrastructure and deploy application code

Run `azd up` to run the end-to-end infrastructure provisioning (`azd provision`) and code deployment (`azd deploy`) flow. Visit the service endpoints listed to see your application up-and-running!

## Details

### What was added

To describe the infrastructure and application, files were added with the following directory structure:

```yaml
- azure.yaml     # azd project configuration
- infra/         # Infrastructure as Code (bicep) files
  - main.bicep   # main deployment module
  - app/         # Application resource modules
  - shared/      # Shared resource modules
  - modules/     # Library modules
```

### Architecture

Each bicep file declares resources to be provisioned. The resources are provisioned when running `azd up` or `azd provision`.

- [app/api-simple.bicep](./infra/app/api-simple.bicep) - Azure Container Apps resources to host the 'api-simple' service.
- [shared/keyvault.bicep](./infra/shared/keyvault.bicep) - Azure KeyVault to store secrets.
- [shared/monitoring.bicep](./infra/shared/monitoring.bicep) - Azure Log Analytics workspace and Application Insights to log and store instrumentation logs.
- [shared/registry.bicep](./infra/shared/registry.bicep) - Azure Container Registry to store docker images.

More information about [bicep](https://aka.ms/bicep).

### Billing

Visit the *Cost Management + Billing* page in Azure Portal to track current spend. For more information about how you're billed, and how you can monitor the costs incurred in your Azure subscriptions, visit [billing overview](https://learn.microsoft.com/en-us/azure/developer/intro/azure-developer-billing).

