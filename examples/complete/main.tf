module "multi_region_backup" {
  source = "../../"

  tenant_key = "acme-corp"
  
  regions = [
    "us-west-2",
    "us-east-2",
    "us-east-1",
    "eu-north-1"
  ]
  
  # Retention settings
  backup_retention_days            = 1   # Retention for snapshot backups and copies
  continuous_backup_retention_days = 1   # Retention for continuous backups (max 35 days)
  
  # Vault lock settings (compliance mode with long changeable window)
  enable_vault_lock              = false   # Enable compliance mode
  vault_lock_changeable_days     = 365    # 1 year to modify lock settings
  vault_lock_min_retention_days  = 1      # Minimum retention enforced
  vault_lock_max_retention_days  = 90      # Maximum retention enforced
}
