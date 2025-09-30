$managementGroups = Get-AzManagementGroup
$subscriptions = Get-AzSubscription

Remove-Item -Path "1.txt" -ErrorAction SilentlyContinue
Remove-Item -Path "Imports.txt" -ErrorAction SilentlyContinue

foreach ($mg in $managementGroups) {
    Write-Host "Processing Management Group '$($mg.DisplayName)'" -foregroundcolor Yellow
    Write-Host ""
    $policyAssignments = Get-AzPolicyAssignment -Scope $mg.Id | Where-Object { $_.Scope -eq $mg.Id }
    if ($policyAssignments.Count -gt 0) {
        
        foreach ($policyAssignment in $policyAssignments) {
            Write-Host " - Processing Management Group Policy Assignment '$($policyAssignment.Name)'" -foregroundcolor Yellow

            Add-Content -Path "Imports.txt" -Value "import {"
            Add-Content -Path "Imports.txt" -Value "  to = module.toreplace.module.management_group_policy_assignment[`"$($policyAssignment.Name)`"].azurerm_management_group_policy_assignment.this"
            Add-Content -Path "Imports.txt" -Value "  id = `"$($policyAssignment.Id)`""
            Add-Content -Path "Imports.txt" -Value "}"
            Add-Content -Path "Imports.txt" -Value ""

            Add-Content -Path "1.txt" -Value "For Policy Definition Id: $($policyAssignment.PolicyDefinitionId)"
            Add-Content -Path "1.txt" -Value ""

            if ($policyAssignment.PolicyDefinitionId -like "/providers/Microsoft.Authorization/policySetDefinitions/*") {
                Add-Content -Path "1.txt" -Value "module `"toreplace`" {"
                Add-Content -Path "1.txt" -Value "  source = `"https://popscazsterraformmodules.blob.core.windows.net/azure-terraform-modules/azurerm_management_group_policy_assignemnt/20250917.zip`""
                #Add-Content -Path "1.txt" -Value "  description = `"$($policyAssignment.Description)`""
                Add-Content -Path "1.txt" -Value "  display_name = `"$($policyAssignment.DisplayName)`""
                Add-Content -Path "1.txt" -Value "  enforce = `"$($policyAssignment.EnforcementMode)`""
                #Add-Content -Path "1.txt" -Value "  expires_on = `"$($policyAssignment.ExpiresOn)`""
                Add-Content -Path "1.txt" -Value "  location = `"$($policyAssignment.Location)`""
                Add-Content -Path "1.txt" -Value "  management_group_id = `"$($policyAssignment.Scope)`""
                Add-Content -Path "1.txt" -Value "  name = `"$($policyAssignment.Name)`""
                Add-Content -Path "1.txt" -Value "  policy_definition_id = `"$($policyAssignment.PolicyDefinitionId)`""
            }

            Add-Content -Path "1.txt" -Value "  management_group_policy_assignments = {"
            Add-Content -Path "1.txt" -Value "    `"$($policyAssignment.Name)`" = {"
            Add-Content -Path "1.txt" -Value "      display_name = `"$($policyAssignment.DisplayName)`""
            Add-Content -Path "1.txt" -Value "      enforce      = true"
            Add-Content -Path "1.txt" -Value "      identity = {"
            Add-Content -Path "1.txt" -Value "        type = `"SystemAssigned`""
            Add-Content -Path "1.txt" -Value "      }"
            Add-Content -Path "1.txt" -Value "      location            = `"East US`""
            Add-Content -Path "1.txt" -Value "      management_group_id = `"$($policyAssignment.Scope)`""
            Add-Content -Path "1.txt" -Value "      policy_definition_id = `"$($policyAssignment.PolicyDefinitionId)`""
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

            if ($policyAssignment.NonComplianceMessage) {
                Add-Content -Path "1.txt" -Value "      non_compliance_message = {"
                Add-Content -Path "1.txt" -Value "        content = `"$($policyAssignment.NonComplianceMessage.message)`""
                Add-Content -Path "1.txt" -Value "      }"
            }

            if ($policyAssignment.psobject.Properties) {
                Add-Content -Path "1.txt" -Value "      parameters = jsonencode({"

                $policyAssignment.Parameter.psobject.Properties | ForEach-Object {
                    Add-Content -Path "1.txt" -Value "        $($_.Name) = {"
                    Add-Content -Path "1.txt" -Value "          value = `"$($_.Value.Value)`"" 
                    Add-Content -Path "1.txt" -Value "        }"
                }

                Add-Content -Path "1.txt" -Value "      })"
            }

            Add-Content -Path "1.txt" -Value "    }"
            Add-Content -Path "1.txt" -Value "  }"

            if ($policyAssignment.PolicyDefinitionId -like "/providers/Microsoft.Authorization/policySetDefinitions/*") {
                Add-Content -Path "1.txt" -Value "}"
            }

            Add-Content -Path "1.txt" -Value ""
        }
    }
}

foreach ($subscription in $subscriptions) {
    Write-Host "Processing Subscription '$($subscription.Id)'" -foregroundcolor Yellow
    Write-Host ""
    $policyAssignments = Get-AzPolicyAssignment -Scope "/subscriptions/$($subscription.Id)" | Where-Object { $_.Scope -eq "/subscriptions/$($subscription.Id)" }
    if ($policyAssignments.Count -gt 0) {
        
        foreach ($policyAssignment in $policyAssignments) {
            Write-Host " - Processing Subscription Policy Assignment '$($policyAssignment.Name)'" -foregroundcolor Yellow

            Add-Content -Path "Imports.txt" -Value "import {"
            Add-Content -Path "Imports.txt" -Value "  to = module.toreplace.module.subscription_policy_assignment[`"$($policyAssignment.Name)`"].azurerm_subscription_policy_assignment.this"
            Add-Content -Path "Imports.txt" -Value "  id = `"$($policyAssignment.Id)`""
            Add-Content -Path "Imports.txt" -Value "}"
            Add-Content -Path "Imports.txt" -Value ""

            Add-Content -Path "1.txt" -Value "For Policy Definition Id: $($policyAssignment.PolicyDefinitionId)"
            Add-Content -Path "1.txt" -Value ""
            Add-Content -Path "1.txt" -Value "  subscription_policy_assignments = {"
            Add-Content -Path "1.txt" -Value "    `"$($policyAssignment.Name)`" = {"
            Add-Content -Path "1.txt" -Value "      display_name = `"$($policyAssignment.DisplayName)`""
            Add-Content -Path "1.txt" -Value "      enforce      = true"
            Add-Content -Path "1.txt" -Value "      identity = {"
            Add-Content -Path "1.txt" -Value "        type = `"SystemAssigned`""
            Add-Content -Path "1.txt" -Value "      }"
            Add-Content -Path "1.txt" -Value "      location            = `"East US`""
            Add-Content -Path "1.txt" -Value "      subscription_id = `"$($policyAssignment.Scope)`""

            if ($policyAssignment.NonComplianceMessage) {
                Add-Content -Path "1.txt" -Value "      non_compliance_message = {"
                Add-Content -Path "1.txt" -Value "        content = `"$($policyAssignment.NonComplianceMessage.message)`""
                Add-Content -Path "1.txt" -Value "      }"
            }

            if ($policyAssignment.psobject.Properties) {
                Add-Content -Path "1.txt" -Value "      parameters = jsonencode({"

                $policyAssignment.Parameter.psobject.Properties | ForEach-Object {
                    Add-Content -Path "1.txt" -Value "        $($_.Name) = {"
                    Add-Content -Path "1.txt" -Value "          value = `"$($_.Value.Value)`"" 
                    Add-Content -Path "1.txt" -Value "        }"
                }

                Add-Content -Path "1.txt" -Value "      })"
            }

            Add-Content -Path "1.txt" -Value "    }"
            Add-Content -Path "1.txt" -Value "  }"
            Add-Content -Path "1.txt" -Value ""
        }
    }
}

