param objectPrincipalID string
param synapseWorkspaceName string

resource r_synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: synapseWorkspaceName

  resource r_workspaceAADAdmin 'administrators' = {
    name:'activeDirectory'
    properties:{
      administratorType:'ActiveDirectory'
      tenantId: subscription().tenantId
      login: 'clintgrove@microsoft.com'
      sid: objectPrincipalID
      //uamiPrincipalID
    }
  }
}
