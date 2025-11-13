output "backup_vault_arns" {
  description = "Map of region to backup vault ARN"
  value = {
    for region, vault in module.vault : region => vault.backup_vault_arn
  }
}

output "backup_vault_ids" {
  description = "Map of region to backup vault ID"
  value = {
    for region, vault in module.vault : region => vault.backup_vault_id
  }
}

output "backup_plan_ids" {
  description = "Map of region to backup plan ID"
  value = {
    for region, plan in module.backup_plan : region => plan.backup_plan_id
  }
}

output "backup_plan_arns" {
  description = "Map of region to backup plan ARN"
  value = {
    for region, plan in module.backup_plan : region => plan.backup_plan_arn
  }
}
