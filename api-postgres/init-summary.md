# Summary for `azd init`

## Generated `infra` files

```yaml
- infra/ # Infrastructure as Code files
  - main.bicep # main deployment module
  - app/ # Application resources
  - shared/ # Shared resources
  - modules/ # Useful library modules
```

Each bicep file declares resources to be provisioned. When running `azd provision` or `azd up`, the resources are provisioned accordingly. Notable resources are as follow:

- [app/api.bicep](./infra/app/api.bicep) - Azure Container Apps resources to host the 'api' service.
- [app/db-postgre.bicep](./infra/app/db-postgres.bicep) - Azure Postgres Flexible Server to host the 'Todo' database.
- [shared/keyvault.bicep](./infra/shared/keyvault.bicep) - Azure KeyVault to store secrets.
- [shared/monitoring.bicep](./infra/shared/monitoring.bicep) - Azure Log Analytics workspace and Application Insights to log and store instrumentation logs.
- [shared/registry.bicep](./infra/shared/registry.bicep) - Azure Container Registry to store docker images.

More information about [bicep](https://aka.ms/bicep).

For billing information, see [some biling page](https://biling).

## Environment variables

Environment variables have been defined under `env` in [api.bicep](./infra/app/api.bicep). Modify existing or define additional environment variables as necessary.

To define a secret as an environment variable, the secret should first be stored in KeyVault.
