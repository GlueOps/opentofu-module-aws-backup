# Generate UUIDs for unique resource naming
resource "random_uuid" "role" {}
resource "random_uuid" "plan" {}
resource "random_uuid" "selection" {}

# Local variables
locals {
  # UUIDs for unique naming
  role_uuid      = random_uuid.role.result
  plan_uuid      = random_uuid.plan.result
  selection_uuid = random_uuid.selection.result
}

# Create IAM role for AWS Backup
resource "aws_iam_role" "backup" {
  name = local.role_uuid

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.tenant_key}-${var.region}-backup-role"
    tenant_name = var.tenant_key
    region      = var.region
    managed_by  = "opentofu"
    uuid        = local.role_uuid
  }
}

# Attach AWS managed policies
resource "aws_iam_role_policy_attachment" "backup_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup",
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores",
    "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Backup",
    "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Restore",
  ])
  
  role       = aws_iam_role.backup.name
  policy_arn = each.value
}

# Create backup plan with continuous backup and cross-region copy
resource "aws_backup_plan" "this" {
  name = local.plan_uuid

  # Continuous backup rule (for supported resources like S3)
  rule {
    rule_name                = "continuous-backup"
    target_vault_name        = var.backup_vault_name
    enable_continuous_backup = true
    schedule                 = var.continuous_backup_schedule
    start_window             = var.continuous_backup_start_window
    completion_window        = var.continuous_backup_completion_window

    lifecycle {
      delete_after = var.continuous_backup_retention_days
    }

    # Copy to all vaults including same-region (AWS handles this correctly)
    dynamic "copy_action" {
      for_each = var.all_vault_arns
      content {
        destination_vault_arn = copy_action.value

        lifecycle {
          delete_after = var.backup_retention_days
        }
      }
    }
  }

  # Snapshot backup rule (hourly for all resources)
  rule {
    rule_name         = "hourly-snapshot-backup"
    target_vault_name = var.backup_vault_name
    schedule          = var.snapshot_schedule
    start_window      = var.snapshot_start_window
    completion_window = var.snapshot_completion_window

    lifecycle {
      delete_after = var.backup_retention_days
    }

    # Copy snapshots to all vaults including same-region (AWS handles this correctly)
    dynamic "copy_action" {
      for_each = var.all_vault_arns
      content {
        destination_vault_arn = copy_action.value

        lifecycle {
          delete_after = var.backup_retention_days
        }
      }
    }
  }

  tags = {
    Name        = "${var.tenant_key}-${var.region}-backup-plan"
    tenant_name = var.tenant_key
    region      = var.region
    managed_by  = "opentofu"
    uuid        = local.plan_uuid
  }
}

# Create backup selection for S3 buckets (excluding -loki- buckets)
resource "aws_backup_selection" "s3" {
  iam_role_arn = aws_iam_role.backup.arn
  name         = local.selection_uuid
  plan_id      = aws_backup_plan.this.id

  resources = ["arn:aws:s3:::*"]
  
  # Exclude buckets with -loki- in the name
  not_resources = ["arn:aws:s3:::*-loki-*"]
}
