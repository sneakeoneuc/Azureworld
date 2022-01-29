
#Add net
$vnet = @{
    Name = 'az-azsmoke-vnet-prod01'
    ResourceGroupName = 'az-azsmoke-vnet'
    Location = 'EastUs'
    AddressPrefix = '10.0.0.0/16'    
}
$virtualNetwork = New-AzVirtualNetwork @vnet


#Add subnet
$subnet = @{
    Name = 'az-azsmoke-vnet-sbn01'
    VirtualNetwork = $virtualNetwork
    AddressPrefix = '10.0.0.0/24'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet

#Associate the subnet to the virtual network
$virtualNetwork | Set-AzVirtualNetwork