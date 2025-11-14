# Define a provider for each region
provider "aws" {
  alias    = "by_region"
  for_each = toset(var.regions)
  region   = each.value

  dynamic "assume_role" {
    for_each = var.assume_role_arn != null ? [1] : []
    content {
      role_arn = var.assume_role_arn
    }
  }
}

# Local variables
locals {
  # Create a map for easy iteration
  regions_map = { for idx, region in var.regions : region => region }
}

# STAGE 1: Create vaults in all regions first
module "vault" {
  source   = "./modules/vault"
  for_each = local.regions_map

  providers = {
    aws = aws.by_region[each.key]
  }

  tenant_key                    = var.tenant_key
  region                        = each.value
  enable_vault_lock             = var.enable_vault_lock
  vault_lock_changeable_days    = var.vault_lock_changeable_days
  vault_lock_min_retention_days = var.vault_lock_min_retention_days
  vault_lock_max_retention_days = var.vault_lock_max_retention_days
}

# STAGE 2: Create backup plans with cross-region copy after vaults exist
module "backup_plan" {
  source   = "./modules/backup-plan"
  for_each = local.regions_map

  providers = {
    aws = aws.by_region[each.key]
  }

  tenant_key                       = var.tenant_key
  region                           = each.value
  backup_vault_name                = module.vault[each.key].backup_vault_name
  backup_vault_arn                 = module.vault[each.key].backup_vault_arn
  backup_retention_days            = var.backup_retention_days
  continuous_backup_retention_days = var.continuous_backup_retention_days

  # Snapshot backup settings
  snapshot_schedule          = var.snapshot_schedule
  snapshot_start_window      = var.snapshot_start_window
  snapshot_completion_window = var.snapshot_completion_window

  # Continuous backup settings
  continuous_backup_schedule          = var.continuous_backup_schedule
  continuous_backup_start_window      = var.continuous_backup_start_window
  continuous_backup_completion_window = var.continuous_backup_completion_window

  # Pass ALL vault ARNs as map for cross-region copy
  all_vault_arns = {
    for dest in var.regions : dest => module.vault[dest].backup_vault_arn
  }
}
