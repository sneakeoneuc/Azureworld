# login to Azure
#Connect-AzAccount

# Connect to Subscription
#$context = Get-AzSubscription -SubscriptionId "xxx-xxx-xxx"
#Set-AzContext $context

#create RG
New-AzResourceGroup -ResourceGroupName AZRSGname -Location EastUS

# Create Subnet
$subnetConfig = New-AzVirtualNetworkSubnetConfig `
-Name PSSubnet `
-AddressPrefix 10.10.1.0/24

# Create Vnet
$vnet = New-AzVirtualNetwork `
-ResourceGroupName AZRSGname `
-Location EastUS `
-Name VNETname `
-AddressPrefix 10.10.0.0/16 `
-Subnet $subnetConfig

# Create PIP
$pip = New-AzPublicIpAddress `
-ResourceGroupName AZRSGname `
-Location EastUS `
-AllocationMethod Static `
-Name PSPIP

# Create NIC
$nic = New-AzNetworkInterface `
-ResourceGroupName AZRSGname `
-Location EastUS `
-Name Nicname `
-SubnetId $vnet.Subnets[0].Id `
-PublicIpAddressId $pip.Id

# Create NSG Rule
$nsgRule = New-AzNetworkSecurityRuleConfig `
-Name NSGname `
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
-Name NSGname `
-Protocol Tcp `
-Direction Inbound `
-Priority 1001 `
-SourceAddressPrefix * `
-SourcePortRange * `
-DestinationAddressPrefix * `
-DestinationPortRange 22 `
-Access Allow

$nsgRule1 = New-AzNetworkSecurityRuleConfig `
-Name NSGRuleAny `
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
-ResourceGroupName AZRSGname `
-Location EastUS `
-Name NSG143IT `
-SecurityRules $nsgRule,$nsgRule1

# Assign NSG to Subnet
Set-AzVirtualNetworkSubnetConfig `
-Name PSSubnet `
-VirtualNetwork $vnet `
-NetworkSecurityGroup $nsg `
-AddressPrefix 10.10.1.0/24

#Update subnet with NSG
Set-AzVirtualNetwork -VirtualNetwork $vnet

#Set Cred for VM
$cred = Get-Credential

#Set Vm config, name and Size
$vmconfig = New-AzVMConfig -VMName newVMname -VMSize Standard_B1ms | `
Set-AzVMOperatingSystem -Windows -ComputerName newVMname -Credential $cred | `
Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2019-Datacenter -Version latest | Add-AzVMNetworkInterface -Id $nic.Id


#Create VM
New-AzVM -ResourceGroupName AZRSGname -Location EastUS -VM $vmconfig

