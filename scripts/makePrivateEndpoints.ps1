#New-AzPrivateEndpoint -Name "pe-azurerm" -ResourceGroupName "rg-azurerm" -Subnet $subnet -PrivateServiceConnectionName "psc-azurerm" -PrivateIpAddress ""
$uri = "https://$SynapseWorkspaceName.dev.azuresynapse.net"
$uri += "/managedVirtualNetworks/default/managedPrivateEndpoints/$managedPrivateEndpointName"
$uri += "?api-version=2019-06-01-preview"