# Generate UUIDs for unique resource naming
resource "random_uuid" "role" {}
resource "random_uuid" "continuous_plan" {}
resource "random_uuid" "snapshot_plan" {}
resource "random_uuid" "continuous_selection" {}
resource "random_uuid" "snapshot_selection" {}

# Local variables
locals {
  # UUIDs for unique naming
  role_uuid                = random_uuid.role.result
  continuous_plan_uuid     = random_uuid.continuous_plan.result
  snapshot_plan_uuid       = random_uuid.snapshot_plan.result
  continuous_selection_uuid = random_uuid.continuous_selection.result
  snapshot_selection_uuid   = random_uuid.snapshot_selection.result
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

# Create continuous backup plan
resource "aws_backup_plan" "continuous" {
  name = local.continuous_plan_uuid

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

    recovery_point_tags = {
      backup_type = "continuous"
      tenant_name = var.tenant_key
      region      = var.region
      managed_by  = "opentofu"
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

  tags = {
    Name        = "${var.tenant_key}-${var.region}-continuous-backup-plan"
    tenant_name = var.tenant_key
    region      = var.region
    managed_by  = "opentofu"
    uuid        = local.continuous_plan_uuid
  }
}

# Create snapshot backup plan
resource "aws_backup_plan" "snapshot" {
  name = local.snapshot_plan_uuid

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

    recovery_point_tags = {
      backup_type = "snapshot"
      tenant_name = var.tenant_key
      region      = var.region
      managed_by  = "opentofu"
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
    Name        = "${var.tenant_key}-${var.region}-snapshot-backup-plan"
    tenant_name = var.tenant_key
    region      = var.region
    managed_by  = "opentofu"
    uuid        = local.snapshot_plan_uuid
  }
}

# Create backup selection for continuous backups (S3 buckets in this region)
resource "aws_backup_selection" "continuous" {
  iam_role_arn = aws_iam_role.backup.arn
  name         = local.continuous_selection_uuid
  plan_id      = aws_backup_plan.continuous.id

  resources = ["arn:aws:s3:::*"]
  
  # Exclude buckets with -loki- in the name
  not_resources = ["arn:aws:s3:::*-loki-*"]
}

# Create backup selection for snapshots (S3 buckets in this region)
resource "aws_backup_selection" "snapshot" {
  iam_role_arn = aws_iam_role.backup.arn
  name         = local.snapshot_selection_uuid
  plan_id      = aws_backup_plan.snapshot.id

  resources = ["arn:aws:s3:::*"]
  
  # Exclude buckets with -loki- in the name
  not_resources = ["arn:aws:s3:::*-loki-*"]
}
