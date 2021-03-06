#Search Azure subscriptions for existing Turbonomic custom role
$turboRoleSubscription = $null
Add-Content -Path .\TurboRoleAddedToSubScope.csv -Value "Subscription Name,Subscription ID,Turbo Custom Role Name"
foreach($azureSubscription in Get-AzureRmSubscription){
 
    #Set the script's focus one subscription at a time
    Select-AzureRmSubscription -Subscription $azureSubscription.Id
 
    #If the Azure custom role is already created, capture the subscription ID
    if(Get-AzureRmRoleDefinition | Where-Object{$_.Name -eq 'Turbonomic Operator ReadOnly'}){
        $turboRoleSubscription = $azureSubscription
        if($turboRoleSubscription){
            Select-AzureRmSubscription -Subscription $azureSubscription.Id
            $targetSubID = $azureSubscription.Id
            $subname = $azureSubscription.Name
            $turboCustomRole = Get-AzureRmRoleDefinition | Where-Object{$_.Name -eq 'Turbonomic Operator ReadOnly'}
            $turboCustomRole.AssignableScopes.Add("/subscriptions/$targetSubID")
            $turboCustomRoleName = $turboCustomRole.Name
            Add-Content -Path .\TurboRoleAddedToSubScope.csv -Value "$subname,$targetSubID,$TurboCustomRoleName"
        }
    }
}