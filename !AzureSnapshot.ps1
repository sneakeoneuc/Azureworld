#Set parameters.

$resourceGroup = 'AZ143RG02'
$location= 'EastUS'
$vmName = "DCVM02"
$snapshotName = 'SQLPatching2022'

#Retrieve the VM.

$vm = Get-AzVM `
     -ResourceGroupName $resourceGroup `
     -Name $vmName

#Create the snapshot configurations.

$snapshot =  New-AzSnapshotConfig `
    -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id `
    -Location $location `
    -CreateOption copy

#Take the snapshot.

New-AzSnapshot `
    -Snapshot $snapshot `
    -SnapshotName $snapshotName `
    -ResourceGroupName $resourceGroup