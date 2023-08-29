targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param apiExists bool
param webExists bool

// Tags that should be applied to all resources.
// 
// Note that 'azd-service-name' tags should be applied separately to service host resources.
// Example usage:
//   tags: union(tags, { 'azd-service-name': <service name in azure.yaml> })
var tags = {
  'azd-env-name': environmentName
}

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module monitoring './core/monitor/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    location: location
    tags: tags
    logAnalyticsName: '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
    applicationInsightsName: '${abbrs.insightsComponents}${resourceToken}'
    applicationInsightsDashboardName: '${abbrs.portalDashboards}${resourceToken}'
  }
  scope: rg
}

module keyVault './core/security/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    location: location
    tags: tags
    name: '${abbrs.keyVaultVaults}${resourceToken}'
  }
  scope: rg
}

// Container apps host (including container registry)
module containerApps './core/host/container-apps.bicep' = {
  name: 'container-apps'
  scope: rg
  params: {
    name: 'app'
    location: location
    tags: tags
    containerAppsEnvironmentName: '${abbrs.appManagedEnvironments}${resourceToken}'
    containerRegistryName: '${abbrs.containerRegistryRegistries}${resourceToken}'
    logAnalyticsWorkspaceName: monitoring.outputs.logAnalyticsWorkspaceName
    applicationInsightsName: monitoring.outputs.applicationInsightsName
  }
}

resource vault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVault.outputs.name
  scope: rg
}

module cosmosDb './app/db-cosmos-mongo.bicep' = {
  name: 'cosmosDb'
  params: {
    accountName: '${abbrs.documentDBDatabaseAccounts}${resourceToken}'
    location: location
    tags: tags
    keyVaultName: keyVault.outputs.name
  }
  scope: rg
}

module api './app/api.bicep' = {
  name: 'api'
  params: {
    name: '${abbrs.appContainerApps}api-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}api-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: containerApps.outputs.environmentName
    containerRegistryName: containerApps.outputs.registryName
    exists: apiExists
    cosmosDbConnectionString: vault.getSecret(cosmosDb.outputs.connectionStringKey)
    allowedOrigins: [
      'https://${abbrs.appContainerApps}web-${resourceToken}.${containerApps.outputs.defaultDomain}'
    ]
  }
  scope: rg
}

module web './app/web.bicep' = {
  name: 'web'
  params: {
    name: '${abbrs.appContainerApps}web-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}web-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: containerApps.outputs.environmentName
    containerRegistryName: containerApps.outputs.registryName
    exists: webExists
    apiUrls: [
      api.outputs.uri
    ]
  }
  scope: rg
}

output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerApps.outputs.registryLoginServer
