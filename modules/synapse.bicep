param synapseDefaultContainerName string
param synapseWorkspaceName string
param resourceLocation string
param azenvironment string
@secure()
param synapseSqlAdminPassword string
param synapseSqlAdminUserName string
param synapseSparkPoolName string
param synapseSparkPoolNodeSize string
param synapseSparkPoolMinNodeCount int
param synapseSparkPoolMaxNodeCount int
param synapseManagedRGName string
param workspaceDataLakeAccountName string
param ctrlDeploySynapseSparkPool bool

// var storageEnvironmentDNS = environment().suffixes.storage
var dataLakeStorageAccountUrl = 'https://${workspaceDataLakeAccountName}.dfs.core.windows.net/'
var azureRBACStorageBlobDataContributorRoleID = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //Storage Blob Data Contributor Role

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
    cspWorkspaceAdminProperties: {
      initialWorkspaceAdminObjectId: '4fe7fc36-b425-420f-a3f4-5e14e084eb5e'
    }
    defaultDataLakeStorage: {
      accountUrl: dataLakeStorageAccountUrl
      createManagedPrivateEndpoint: false
      filesystem: synapseDefaultContainerName
    }


    publicNetworkAccess: 'Enabled'
    sqlAdministratorLogin: synapseSqlAdminUserName
    sqlAdministratorLoginPassword:  synapseSqlAdminPassword
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

resource symbolicname 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = {
  name: 'SynapseFirewall'
  parent: r_synapseWorkspace
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

//Data Lake Storage Account
resource r_workspaceDataLakeAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: workspaceDataLakeAccountName
  location: resourceLocation
  properties:{
    isHnsEnabled: true
    accessTier:'Hot'
    networkAcls: {
      defaultAction: 'Deny' 
      bypass:'None'
      resourceAccessRules: [
        {
          tenantId: subscription().tenantId
          resourceId: r_synapseWorkspace.id
        }
    ]
    }
  }
  kind:'StorageV2'
  sku: {
      name: 'Standard_LRS'
  }
}

//Synapse Workspace Role Assignment as Blob Data Contributor Role in the Data Lake Storage Account
//https://docs.microsoft.com/en-us/azure/synapse-analytics/security/how-to-grant-workspace-managed-identity-permissions
resource r_dataLakeRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid(r_synapseWorkspace.name, r_workspaceDataLakeAccount.name)
  scope: r_workspaceDataLakeAccount
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACStorageBlobDataContributorRoleID)
    principalId: r_synapseWorkspace.identity.principalId
    principalType:'ServicePrincipal'
  }
}



output workspaceDataLakeAccountID string = r_workspaceDataLakeAccount.id
output workspaceDataLakeAccountName string = r_workspaceDataLakeAccount.name
output synapseWorkspaceID string = r_synapseWorkspace.id
output synapseWorkspaceName string = r_synapseWorkspace.name
output synapseSQLDedicatedEndpoint string = r_synapseWorkspace.properties.connectivityEndpoints.sql
output synapseSQLServerlessEndpoint string = r_synapseWorkspace.properties.connectivityEndpoints.sqlOnDemand
output synapseWorkspaceSparkID string =  r_synapseWorkspace::r_sparkPool.id 
output synapseWorkspaceSparkName string =  r_synapseWorkspace::r_sparkPool.name 
output synapseWorkspaceIdentityPrincipalID string = r_synapseWorkspace.identity.principalId
