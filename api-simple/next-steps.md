# Next Steps

## Table of Contents
1. [Next Steps](#next-steps)
2. [What was added](#what-was-added)
3. [Billing](#billing)
4. [Troubleshooting](#troubleshooting)

## Next Steps
### Define environment variables for running services

Modify or add environment variables to configure the running application. Environment variables can be configured by modifying the `env` node in the following files:

- [app/api-simple.bicep](./infra/app/api-simple.bicep)

To define a secret as an environment variable, the secret can first be stored in KeyVault.

### Provision infrastructure and deploy application code

Run `azd up` to provision your infrastructure and deploy to Azure in one step (or run `azd provision` then `azd deploy` to accomplish the tasks separately). Visit the service endpoints from the command outut to see your application up-and-running!

Note: To troubleshoot any issues, see [troubleshooting](#troubleshooting).

## What was added

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

- [app/api-simple.bicep](./infra/app/api-simple.bicep) - Azure Container Apps resources to host the 'api-simple' service.
- [shared/keyvault.bicep](./infra/shared/keyvault.bicep) - Azure KeyVault to store secrets.
- [shared/monitoring.bicep](./infra/shared/monitoring.bicep) - Azure Log Analytics workspace and Application Insights to log and store instrumentation logs.
- [shared/registry.bicep](./infra/shared/registry.bicep) - Azure Container Registry to store docker images.

More information about [Bicep](https://aka.ms/bicep).

If your project does not contain a Dockerfile, we will use [Buildpacks](https://buildpacks.io/) to create an image for the services in `azure.yaml` and get your containerized app onto Azure. 

## Billing

Visit the *Cost Management + Billing* page in Azure Portal to track current spend. For more information about how you're billed, and how you can monitor the costs incurred in your Azure subscriptions, visit [billing overview](https://learn.microsoft.com/en-us/azure/developer/intro/azure-developer-billing).

## Troubleshooting

Q: I visited the service endpoint listed, and I'm seeing a blank or error page.

A: Your service may have failed to start or misconfigured. To investigate further:

1. Click on the resource group link shown to visit Azure Portal.
2. Navigate to the specific Azure Container App resource for the service.
3. Select *Monitoring -> Log stream* under the navigation pane.
4. Observe the log output to identify any errors.
5. If there are no errors, ensure that the ingress port matches the port that your service listens on:
    1. Under *Settings -> Ingress*, ensure the *Target port* matches the desired port.
    2. After modifying this setting, ensure the setting is also updated in the local bicep configuration file.

For additional information about setting up your `azd` project, visit our official [docs](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/make-azd-compatible?pivots=azd-convert).
