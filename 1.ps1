$managementGroups = Get-AzManagementGroup
$subscriptions = Get-AzSubscription

foreach ($mg in $managementGroups) {
    Write-Host "Processing Management Group '$($mg.DisplayName)'"
    Write-Host ""
    $policyAssignments = Get-AzPolicyAssignment -Scope $mg.Id | Where-Object { $_.Scope -eq $mg.Id }
    if ($policyAssignments.Count -gt 0) {
        
        foreach ($policyAssignment in $policyAssignments) {

            Add-Content -Path "Imports.txt" -Value "import {"
            Add-Content -Path "Imports.txt" -Value "  to = module.toreplace.module.management_group_policy_assignment[`"$($policyAssignment.Name)`"].azurerm_management_group_policy_assignment.this"
            Add-Content -Path "Imports.txt" -Value "  id = `"$($policyAssignment.Id)`""
            Add-Content -Path "Imports.txt" -Value "}"
            Add-Content -Path "Imports.txt" -Value ""

            Add-Content -Path "1.txt" -Value "For Policy Definition Id: $($policyAssignment.PolicyDefinitionId)"
            Add-Content -Path "1.txt" -Value ""
            Add-Content -Path "1.txt" -Value "  management_group_policy_assignments = {"
            Add-Content -Path "1.txt" -Value "    `"$($policyAssignment.Name)`" = {"
            Add-Content -Path "1.txt" -Value "      display_name = `"$($policyAssignment.DisplayName)`""
            Add-Content -Path "1.txt" -Value "      enforce      = true"
            Add-Content -Path "1.txt" -Value "      identity = {"
            Add-Content -Path "1.txt" -Value "        type = `"SystemAssigned`""
            Add-Content -Path "1.txt" -Value "      }"
            Add-Content -Path "1.txt" -Value "      location            = `"East US`""
            Add-Content -Path "1.txt" -Value "      management_group_id = `"$($policyAssignment.Scope)`""
            Add-Content -Path "1.txt" -Value "      management_group_policy_exemptions = {"

            foreach ($managementGroupException in $managementGroups) {
                Write-Host "Checking for exemptions in Management Group '$($managementGroupException.DisplayName)' - Get-AzPolicyExemption -PolicyAssignmentIdFilter $($policyAssignment.Id) -Scope $($managementGroupException.Id)"
                $managementGroupPolicyExemptions = Get-AzPolicyExemption -PolicyAssignmentIdFilter $policyAssignment.Id -Scope $managementGroupException.Id
                foreach ($exemption in $managementGroupPolicyExemptions) {
                    Write-Host " - Found exemption '$($exemption.Name)'"

                    Add-Content -Path "Imports.txt" -Value "import {"
                    Add-Content -Path "Imports.txt" -Value "  to = module.toreplace.module.management_group_policy_assignment[`"$($policyAssignment.Name)`"].azurerm_management_group_policy_assignment.this[`"$($exemption.Name)`"]"
                    Add-Content -Path "Imports.txt" -Value "  id = `"$($exemption.Id)`""
                    Add-Content -Path "Imports.txt" -Value "}"
                    Add-Content -Path "Imports.txt" -Value ""
                    
                    Add-Content -Path "1.txt" -Value "        `"$($exemption.Name)`" = {"
                    Add-Content -Path "1.txt" -Value "          management_group_id = `"$($managementGroupException.Id)`""
                    Add-Content -Path "1.txt" -Value "          exemption_category  = `"$($exemption.ExemptionCategory)`""
                    Add-Content -Path "1.txt" -Value "        }"
                }
            }
            Add-Content -Path "1.txt" -Value "      }"
            Add-Content -Path "1.txt" -Value "      subscription_policy_exemptions = {"
            foreach ($subscriptionException in $subscriptions) {
                Write-Host "Checking for exemptions in Subscription '$($subscriptionException.Name)' - Get-AzPolicyExemption -PolicyAssignmentIdFilter $($policyAssignment.Id) -Scope '/subscriptions/$($subscriptionException.Id)'"
                $subscriptionPolicyExemptions = Get-AzPolicyExemption -PolicyAssignmentIdFilter $policyAssignment.Id -Scope "/subscriptions/$($subscriptionException.Id)"
                foreach ($exemption in $subscriptionPolicyExemptions) {
                    Write-Host " - Found exemption '$($exemption.Name)'"

                    Add-Content -Path "Imports.txt" -Value "import {"
                    Add-Content -Path "Imports.txt" -Value "  to = module.toreplace.module.management_group_policy_assignment[`"$($policyAssignment.Name)`"].azurerm_subscription_policy_exemption.this[`"$($exemption.Name)`"]"
                    Add-Content -Path "Imports.txt" -Value "  id = `"$($exemption.Id)`""
                    Add-Content -Path "Imports.txt" -Value "}"
                    Add-Content -Path "Imports.txt" -Value ""
                    
                    Add-Content -Path "1.txt" -Value "        `"$($exemption.Name)`" = {"
                    Add-Content -Path "1.txt" -Value "          subscription_id = `"/subscriptions/$($subscriptionException.Id)`""
                    Add-Content -Path "1.txt" -Value "          exemption_category  = `"$($exemption.ExemptionCategory)`""
                    Add-Content -Path "1.txt" -Value "        }"
                }
            }

            Add-Content -Path "1.txt" -Value "      }"
            Add-Content -Path "1.txt" -Value "    }"
            Add-Content -Path "1.txt" -Value "  }"
            Add-Content -Path "1.txt" -Value ""
        }
        
    }
    
}


