
# Next Steps

## 1. Define environment variables for running services

Modify or add environment variables to configure the running application. Environment variables can be configured by modifying the `env` node in the following files:

- [app/the-cat-said-no.bicep](./infra/app/the-cat-said-no.bicep)

To define a secret as an environment variable, the secret can first be stored in KeyVault.

## 2. Provision infrastructure and deploy application code

Run `azd up` to run the end-to-end infrastructure provisioning (`azd provision`) and code deployment (`azd deploy`) flow. Visit the service endpoints listed to see your application up-and-running!

To troubleshoot any issues, see [troubleshooting](#troubleshooting).

## Details

### What was added

To describe the infrastructure and application, `azure.yaml` along with Infrastructure as Code files using Bicep were added with the following directory structure:

```yaml
- azure.yaml     # azd project configuration
- infra/         # Infrastructure as Code (bicep) files
  - main.bicep   # main deployment module
  - app/         # Application resource modules
  - shared/      # Shared resource modules
  - modules/     # Library modules
```

Each bicep file declares resources to be provisioned. The resources are provisioned when running `azd up` or `azd provision`.

- [app/the-cat-said-no.bicep](./infra/app/the-cat-said-no.bicep) - Azure Container Apps resources to host the 'the-cat-said-no' service.
- [shared/keyvault.bicep](./infra/shared/keyvault.bicep) - Azure KeyVault to store secrets.
- [shared/monitoring.bicep](./infra/shared/monitoring.bicep) - Azure Log Analytics workspace and Application Insights to log and store instrumentation logs.
- [shared/registry.bicep](./infra/shared/registry.bicep) - Azure Container Registry to store docker images.

More information about [Bicep](https://aka.ms/bicep) language.

### Billing

Visit the *Cost Management + Billing* page in Azure Portal to track current spend. For more information about how you're billed, and how you can monitor the costs incurred in your Azure subscriptions, visit [billing overview](https://learn.microsoft.com/en-us/azure/developer/intro/azure-developer-billing).

### Troubleshooting

Q: I visited the service endpoint listed, and I'm seeing a blank or error page.

A: Your service may have failed to start or misconfigured. To investigate further:

1. Click on the resource group link shown to visit Azure Portal.
1. Navigate to the specific Azure Container App resource for the service.
1. Select *Monitoring -> Log stream* under the navigation pane.
1. Observe the log output to identify any errors.
1. If there are no errors, ensure that the ingress port matches the port that your service listens on:
    1. Under *Settings -> Ingress*, ensure the *Target port* matches the desired port.
    1. After modifying this setting, ensure the setting is also updated in the local bicep configuration file.

For additional information about setting up your `azd` project, visit our official [docs](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/make-azd-compatible?pivots=azd-convert).
