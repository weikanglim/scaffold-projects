# Summary for `azd init`

## What was added

To describe the infrastructure and application, files were added with the following directory structure:

```yaml
- azure.yaml     # azd project configuration
- infra/         # Infrastructure as Code files
  - main.bicep   # main deployment module
  - app/         # Application resource modules
  - shared/      # Shared resource modules
  - modules/     # Library modules
```

## Architecture

Each bicep file declares resources to be provisioned. The resources are provisioned when running `azd up` or `azd provision`.

- [app/api.bicep](./infra/app/api.bicep) - Azure Container Apps resources to host the 'api' service.
- [app/db-postgre.bicep](./infra/app/db-postgre.bicep) - Azure Postgres Flexible Server to host the 'Todo' database.
- [shared/keyvault.bicep](./infra/shared/keyvault.bicep) - Azure KeyVault to store secrets.
- [shared/monitoring.bicep](./infra/shared/monitoring.bicep) - Azure Log Analytics workspace and Application Insights to log and store instrumentation logs.
- [shared/registry.bicep](./infra/shared/registry.bicep) - Azure Container Registry to store docker images.

More information about [bicep](https://aka.ms/bicep).

## Billing

Visit the *Cost Management + Billing* page in Azure Portal to track current spend. For more information about how you're billed, and how you can monitor the costs incurred in your Azure subscriptions, visit [billing overview](https://learn.microsoft.com/en-us/azure/developer/intro/azure-developer-billing).

## Next Steps

### Define environment variables for running services

Environment variables have been defined under `env` in [infra/app/api.bicep](./infra/app/api.bicep) for running services. Define additional environment variables as necessary.

To define a secret as an environment variable, the secret should first be stored in KeyVault.

### Provision infrastructure and deploy application code

Run `azd up` to run the end-to-end infrastructure provisioning (`azd provision`) and deployment (`azd deploy`) flow. Visit the service endpoints listed to see your application up-and-running!

Learn more about:

- [Fingerprinting](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/make-azd-compatible?pivots=azd-convert)
