# login to Azure
#Connect-AzAccount

# Connect to Subscription
#$context = Get-AzSubscription -SubscriptionId 7daa7f89-230f-4552-bedc-2b4780dca8ad
#Set-AzContext $context

#create RG
New-AzResourceGroup -ResourceGroupName AZ143RG02 -Location EastUS

# Create Subnet
$subnetConfig = New-AzVirtualNetworkSubnetConfig `
-Name PSSubnet `
-AddressPrefix 172.101.1.0/24

# Create Vnet
$vnet = New-AzVirtualNetwork `
-ResourceGroupName AZ143RG02 `
-Location EastUS `
-Name 143ITVnet `
-AddressPrefix 172.101.0.0/16 `
-Subnet $subnetConfig

# Create PIP
$pip = New-AzPublicIpAddress `
-ResourceGroupName AZ143RG02 `
-Location EastUS `
-AllocationMethod Static `
-Name PSPIP

# Create NIC
$nic = New-AzNetworkInterface `
-ResourceGroupName AZ143RG02 `
-Location EastUS `
-Name Nic143001 `
-SubnetId $vnet.Subnets[0].Id `
-PublicIpAddressId $pip.Id

# Create NSG Rule
$nsgRule = New-AzNetworkSecurityRuleConfig `
-Name NSG143ITRuleRDP `
-Protocol Tcp `
-Direction Inbound `
-Priority 1000 `
-SourceAddressPrefix * `
-SourcePortRange * `
-DestinationAddressPrefix * `
-DestinationPortRange 3389 `
-Access Allow

# Create NSG Rule
$nsgRule = New-AzNetworkSecurityRuleConfig `
-Name NSG143ITRuleRDP `
-Protocol Tcp `
-Direction Inbound `
-Priority 1001 `
-SourceAddressPrefix * `
-SourcePortRange * `
-DestinationAddressPrefix * `
-DestinationPortRange 22 `
-Access Allow

$nsgRule1 = New-AzNetworkSecurityRuleConfig `
-Name NSG143ITRuleAny `
-Protocol Tcp `
-Direction Inbound `
-Priority 1002 `
-SourceAddressPrefix * `
-SourcePortRange * `
-DestinationAddressPrefix * `
-DestinationPortRange * `
-Access Allow

# Create NSG
$nsg = New-AzNetworkSecurityGroup `
-ResourceGroupName AZ143RG02 `
-Location EastUS `
-Name NSG143IT `
-SecurityRules $nsgRule,$nsgRule1

# Assign NSG to Subnet
Set-AzVirtualNetworkSubnetConfig `
-Name PSSubnet `
-VirtualNetwork $vnet `
-NetworkSecurityGroup $nsg `
-AddressPrefix 172.101.1.0/24

#Update subnet with NSG
Set-AzVirtualNetwork -VirtualNetwork $vnet

#Set Cred for VM
$cred = Get-Credential

#Set Vm config, name and Size
$vmconfig = New-AzVMConfig -VMName DCVM02 -VMSize Standard_B1ms | `
Set-AzVMOperatingSystem -Windows -ComputerName DCVM02 -Credential $cred | `
Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2019-Datacenter -Version latest | Add-AzVMNetworkInterface -Id $nic.Id


#Create VM
New-AzVM -ResourceGroupName AZ143RG02 -Location EastUS -VM $vmconfig


