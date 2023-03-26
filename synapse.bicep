resource r_synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: synapseWorkspaceName 
  location: resourceLocation
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  identity:{
    type:'SystemAssigned'
  }
  properties: {
    azureADOnlyAuthentication: true
    connectivityEndpoints: {}

    defaultDataLakeStorage: {
      accountUrl: dataLakeStorageAccountUrl
      createManagedPrivateEndpoint: false
      filesystem: synapseDefaultContainerName
    }


    publicNetworkAccess: 'Enabled'

    sqlAdministratorLogin: synapseSqlAdminUserName
    sqlAdministratorLoginPassword:  synapseSqlAdminPassword
    //publicNetworkAccess: Post Deployment Script will disable public network access for vNet integrated deployments.
    managedResourceGroupName: synapseManagedRGName
    managedVirtualNetwork: 'default' 
    managedVirtualNetworkSettings: {preventDataExfiltration:true}
  }

    //Spark Pool
    resource r_sparkPool 'bigDataPools' = if(ctrlDeploySynapseSparkPool == true){
      name: synapseSparkPoolName
      location: resourceLocation
      properties:{
        autoPause:{
          enabled:true
          delayInMinutes: 15
        }
        nodeSize: synapseSparkPoolNodeSize
        nodeSizeFamily:'MemoryOptimized'
        sparkVersion: '2.4'
        autoScale:{
          enabled:true
          minNodeCount: synapseSparkPoolMinNodeCount
          maxNodeCount: synapseSparkPoolMaxNodeCount
        }
      }
    }
}
