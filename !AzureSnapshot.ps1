#Set parameters.
$resourceGroup = 'RSGname'
$location= "canadacentral"
$vmName = "VMname"
$snapshotName = 'Snapname'
#$tags += @{Empty=$null; Department="IT";Owner="RobLo";Team="Networking"}
#$tag @{Empty=$null; Department="IT";Owner="RobLo";Team="Networking"}

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
    

#Getsnap
 #   Get-AzSnapshot `
 #   -ResourceGroupName $resourceGroupName
