param name string
param location string = resourceGroup().location
param tags object = {}

param identityName string
param containerRegistryName string
param containerAppsEnvironmentName string
param applicationInsightsName string
@secure()
param cosmosDbConnectionString string
param allowedOrigins array
param exists bool

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}

module app '../core/host/container-app-upsert.bicep' = {
  name: 'api-container-app'
  params: {
    name: name
    location: location
    tags: union(tags, { 'azd-service-name': 'api' })
    identityType: 'UserAssigned'
    identityName: identity.name
    exists: exists
    containerAppsEnvironmentName: containerAppsEnvironmentName
    containerRegistryName: containerRegistryName
    containerCpuCoreCount: '1.0'
    containerMemory: '2.0Gi'
    ingressEnabled: true
    external: true
    targetPort: 3100
    allowedOrigins: union(allowedOrigins, [
        // define additional allowed origins here
      ])
    secrets: [
      {
        name: 'azure-cosmos-connection-string'
        value: cosmosDbConnectionString
      }
    ]
    env: [
      {
        name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: applicationInsights.properties.ConnectionString
      }
      {
        name: 'AZURE_COSMOS_MONGODB_CONNECTION_STRING'
        secretRef: 'azure-cosmos-connection-string'
      }
      {
        name: 'PORT'
        value: '3100'
      }
    ]
  }
}

output name string = app.outputs.name
output uri string = app.outputs.uri
