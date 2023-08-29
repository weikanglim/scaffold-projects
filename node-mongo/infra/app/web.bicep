param name string
param location string = resourceGroup().location
param tags object = {}

param identityName string
param containerRegistryName string
param containerAppsEnvironmentName string
param applicationInsightsName string
param apiUrls array
param exists bool

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}

module app '../core/host/container-app-upsert.bicep' = {
  name: 'web-container-app'
  params: {
    name: name
    location: location
    tags: union(tags, { 'azd-service-name': 'web' })
    identityType: 'UserAssigned'
    identityName: identity.name
    exists: exists
    containerAppsEnvironmentName: containerAppsEnvironmentName
    containerRegistryName: containerRegistryName
    containerCpuCoreCount: '1.0'
    containerMemory: '2.0Gi'
    ingressEnabled: true
    external: true
    targetPort: 3101
    secrets: [
    ]
    env: [
      {
        name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: applicationInsights.properties.ConnectionString
      }
      {
        name: 'API_BASE_URL'
        value: apiUrls[0]
      }
      {
        name: 'PORT'
        value: '3101'
      }
    ]
  }
}

output name string = app.outputs.name
output uri string = app.outputs.uri
