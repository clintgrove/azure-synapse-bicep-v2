// Source https://github.com/Azure/azure-synapse-analytics-end2end/blob/main/Deploy/modules/SynapseDeploy.bicep
//Synapse Workspace Parameters
@description('Synapse Workspace Name')
param synapseWorkspaceName string = 'groovywstest'

@description('SQL Admin User Name')
param synapseSqlAdminUserName string = 'sqladmin'

@description('SQL Admin User Password')
@secure()
param synapseSqlAdminPassword string

param azenvironment string = 'test'

param resourceLocation string = 'uk south'

@description('Spark Pool Name')
param synapseSparkPoolName string = 'SparkPool'

@description('Spark Node Size')
param synapseSparkPoolNodeSize string = 'Small'

@description('Spark Min Node Count')
param synapseSparkPoolMinNodeCount int = 3

@description('Spark Max Node Count')
param synapseSparkPoolMaxNodeCount int = 3

@description('Synapse Managed Resource Group Name')
param synapseManagedRGName string = '${synapseWorkspaceName}-mrg2'

//Data Lake Parameters
@description('Synapse Workspace Data Lake Storage Account Name')
param workspaceDataLakeAccountName string = 'stgaccgroovytest'

@description('Synapse Workspace Data Lake Storage Container Name')
param synapseDefaultContainerName string = 'stgaccgroovytest'

@description('Deploy Spark Pool')
param ctrlDeploySynapseSparkPool bool = true

//********************************************************
// Synapse Services 
//********************************************************
module m_SynapseDeploy 'modules/synapse.bicep' = {
  name: 'SynapseDeploy'
  params: {
    ctrlDeploySynapseSparkPool: ctrlDeploySynapseSparkPool
    workspaceDataLakeAccountName: workspaceDataLakeAccountName
    synapseManagedRGName: synapseManagedRGName
    synapseSparkPoolMaxNodeCount: synapseSparkPoolMaxNodeCount
    synapseSparkPoolMinNodeCount: synapseSparkPoolMinNodeCount
    synapseSparkPoolName: synapseSparkPoolName
    synapseSparkPoolNodeSize: synapseSparkPoolNodeSize
    resourceLocation: resourceLocation
    azenvironment: azenvironment
    synapseSqlAdminPassword: synapseSqlAdminPassword
    synapseSqlAdminUserName: synapseSqlAdminUserName
    synapseWorkspaceName: synapseWorkspaceName
    synapseDefaultContainerName: synapseDefaultContainerName
  }
}

// module m_ServiceConnections 'modules/serviceconnections.bicep' = {
//   dependsOn:[
//     m_SynapseDeploy
//   ]
//   name: 'ServiceConnections'
//   params:{
//     synapseWorkspaceName: m_SynapseDeploy.outputs.synapseWorkspaceName
//     objectPrincipalID: '4fe7fc36-b425-420f-a3f4-5e14e084eb5e'
//   }
// }
