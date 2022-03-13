#####Create a New Resource Group#####
{
#Create New Resource Group with tags
New-AzResourceGroup -Name "az-azsmoke-vnet" -Location "eastus" -Tag @{Empty=$null; Department="IT";Owner="RobLo"}
New-AzResourceGroup -Name "az-azsmoke-vnet" -Location "eastus" -Tag @{Empty=$null; Department="IT";Owner="RoberLo"}

#Create New Resouce Group with using input
$resourceGroupName = Read-Host -Prompt "Enter the Resource Group name"
$location = Read-Host -Prompt "Enter the location (i.e. centralus)"
New-AzResourceGroup -Name $resourceGroupName -Location $location

Get-AzResourceGroup -Name $resourceGroupName

#Create New Resource Group single line
New-AzResourceGroup -ResourceGroupName "AZRG-143IT-DEV" -Location "Eastus"
New-AzResourceGroup -ResourceGroupName "AZRG-143IT-DEV2" -Location "Eastus"
New-AzResourceGroup -ResourceGroupName "AZRG-143IT-AA" -Location "Canadacentral"
}

#Removing ResourceGroup
{
Get-AzResourceGroup -Location eastus
Get-AzResourceGroup | Format-Table
Remove-AzResourceGroup -Name AZRG-143IT-PROD-NON
Remove-AzResourceGroup -Name azsmokeautoRG -AsJob
Remove-AzResourceGroup -Name AZRG-143IT-DEV-NON
Remove-AzResourceGroup -Name AZRG-143IT-PROD
Remove-AzResourceGroup -Name cloud-shell-storage-eastus
}

#Get Resource Groups
Get-AzResourceGroup | Select-Object ResourceGroupName, Location


# put resource group in a variable so you can use the same group name going forward,
{
$resourceGroup = "143itRG01"
$location = "eastus"
New-AzResourceGroup -Name $resourceGroup -Location $location
}

#List Resourcegroups 
{
Get-AzResourceGroup | Format-Table -GroupBy Location ResourceGroupName,ProvisioningState,Tags #| Sort Location,ResourceGroupName 
}
#List Resources in ResourceGroup
{
Get-AzResource -ResourceGroupName az-azsmoke-vnet | ft
}


#Cleanup resourcegroups
Get-AzResourceGroup -Name 'azrg-143it*'
Get-AzResourceGroup -Name 'azrg-143it*' | Remove-AzResourceGroup -Force -AsJob

#Connect-AzAccount
Get-AzSubscription

$resourceGroupName = Read-Host -Prompt "Enter the Resource Group name"
$location = Read-Host -Prompt "Enter the location (i.e. centralus)"

New-AzResourceGroup -Name $resourceGroupName -Location $location

$resourceGroupName = Read-Host -Prompt "Enter the Resource Group name"
$location = Read-Host -Prompt "Enter the location (i.e. eastus,centralus,canadaeast)"
