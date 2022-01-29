param([string]$resourceGroup)

$adminCredential = Get-Credential -Message "Enter a username and password for the VM administrator."

For ($i = 1; $i -le 3; $i++)
{
    $vmName = "AZ143IT101" + $i
    Write-Host "Creating VM: " $vmName
    New-AzVm -ResourceGroupName "AZ143RG03" -Name $vmName -Credential $adminCredential -Image Win2016Datacenter -Size "Standard_B1ms" -VirtualNetworkName "az-azsmoke-vnet-prod" -SubnetName "az-azsmoke-vnet-prod-sbn" -SecurityGroupName "nsg1"
}