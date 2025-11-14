# Generate UUID for unique resource naming
resource "random_uuid" "vault" {}

# Local variables
locals {
  # UUID for unique naming
  uuid = random_uuid.vault.result
}

# Create a backup vault for this region
resource "aws_backup_vault" "this" {
  name          = local.uuid
  force_destroy = var.enable_vault_lock ? false : true
  
  tags = {
    Name        = "${var.tenant_key}-${var.region}-backup"
    tenant_name = var.tenant_key
    region      = var.region
    managed_by  = "opentofu"
    uuid        = local.uuid
  }
}

# Enable vault lock (compliance mode) if enabled
resource "aws_backup_vault_lock_configuration" "this" {
  count = var.enable_vault_lock ? 1 : 0
  
  backup_vault_name   = aws_backup_vault.this.name
  changeable_for_days = var.vault_lock_changeable_days
  min_retention_days  = var.vault_lock_min_retention_days
  max_retention_days  = var.vault_lock_max_retention_days
  
  # IMPORTANT: This enables COMPLIANCE mode (prevents deletion even by root)
  # Without this, it's governance mode (can be overridden with permissions)
}
