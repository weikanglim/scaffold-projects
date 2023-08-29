param accountName string
param location string = resourceGroup().location
param tags object = {}

param keyVaultName string

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: accountName
  kind: 'MongoDB'
  location: location
  tags: tags
  properties: {
    consistencyPolicy: { defaultConsistencyLevel: 'Session' }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    apiProperties: { serverVersion: '4.0' }
    capabilities: [ { name: 'EnableServerless' } ]
  }
}
resource database 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2022-05-15' = {
  parent: account
  name: 'appdb'
  properties: {
    resource: {
      id: 'appdb'
    }
  }
}


resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource cosmosConnectionString 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: keyVault
  name: 'cosmosConnectionString'
  properties: {
    value: account.listConnectionStrings().connectionStrings[0].connectionString
  }
}

// By default, no tables/collections are created.
// If you would like to create collections as part of infrastructure provisioning, uncomment below.
// var collection1Name = 'Table1'
// resource collection1 'Microsoft.DocumentDb/databaseAccounts/mongodbDatabases/collections@2022-05-15' = {
//   parent: database
//   name: collection1Name
//   properties: {
//     resource: {
//       id: collection1Name
//       shardKey: { _id: 'Hash' } // use hash(_id) as the partition key
//       indexes: [
//         // Default index on id
//         { key: { keys: ['_id' ]} }
//       ]
//     }
//   }
// }

output accountName string = account.name
output connectionStringKey string = 'cosmosConnectionString'
