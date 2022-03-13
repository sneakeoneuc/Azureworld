param([string]$resourceGroup)

$adminCredential = Get-Credential -Message "Enter a username and password for the VM administrator."

For ($i = 1; $i -le 2; $i++)
{
    $vmName = "VMname" + $i
    Write-Host "Creating VM: " $vmName
    New-AzVm -ResourceGroupName "RSGname" -Name $vmName -Credential $adminCredential -Image Win2016Datacenter -Size "Standard_B1ms" -VirtualNetworkName "VNETname" -SubnetName "SUBNETname" -SecurityGroupName "NSGname"
}