#Connect to Azure
Connect-AzAccount

#Set Az Sub
Get-AzSubscription 
Select-AzSubscription -Subscription "My Subscription"

#Set Variables
$resourceGroupName = "Terraform"
$spName = "SP-DEMO-WE"
$spPassword = "testingthesystem"
$credentials = New-Object Microsoft.Azure.Commands.ActiveDirectory.PSADPasswordCredential `
               -Property @{StartDate=Get-Date; EndDate=Get-Date -Year 2023; Password=$spPassword};
$spConfig = @{
              DisplayName = $spName
              PasswordCredential = $credentials
             }

#Create An Azure SP
$servicePrincipal = New-AzAdServicePrincipal @spConfig    

#Assign a Role to the service principal account
$subscriptionId = (Get-AzContext).Subscription.Id
$spRoleAssignment = @{
                      ObjectId = $servicePrincipal.id;
                      RoleDefinitionName = 'Contributor';
                      Scope = "/subscriptions/c82c18dc-6080-4480-992b-f6544b5789af"
                     }
New-AzRoleAssignment @spRoleAssignment


#Verify accesss
$servicePrincipal.ApplicationId
$credentials = Get-Credential
$tenantId = (Get-AzContext).Tenant.Id

#Connect
Connect-AzAccount -ServicePrincipal -Credential $credentials -Tenant $tenantId