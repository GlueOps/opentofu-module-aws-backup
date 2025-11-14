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

output "continuous_backup_plan_ids" {
  description = "Map of region to continuous backup plan ID"
  value = {
    for region, plan in module.backup_plan : region => plan.continuous_backup_plan_id
  }
}

output "snapshot_backup_plan_ids" {
  description = "Map of region to snapshot backup plan ID"
  value = {
    for region, plan in module.backup_plan : region => plan.snapshot_backup_plan_id
  }
}

output "continuous_backup_plan_arns" {
  description = "Map of region to continuous backup plan ARN"
  value = {
    for region, plan in module.backup_plan : region => plan.continuous_backup_plan_arn
  }
}

output "snapshot_backup_plan_arns" {
  description = "Map of region to snapshot backup plan ARN"
  value = {
    for region, plan in module.backup_plan : region => plan.snapshot_backup_plan_arn
  }
}
