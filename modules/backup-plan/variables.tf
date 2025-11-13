variable "tenant_key" {
  description = "Unique identifier for the tenant"
  type        = string
}

variable "region" {
  description = "AWS region for this backup plan"
  type        = string
}

variable "backup_vault_name" {
  description = "Name of the backup vault to use"
  type        = string
}

variable "backup_vault_arn" {
  description = "ARN of the backup vault (for reference)"
  type        = string
}

variable "all_vault_arns" {
  description = "Map of region to vault ARN for cross-region copy"
  type        = map(string)
  default     = {}
}

variable "backup_retention_days" {
  description = "Number of days to retain backups in the primary vault"
  type        = number
  default     = 7
}

variable "continuous_backup_retention_days" {
  description = "Number of days to retain continuous backups (max 35 days)"
  type        = number
  default     = 35
}

variable "snapshot_schedule" {
  description = "Cron expression for snapshot backup schedule"
  type        = string
  default     = "cron(0 * * * ? *)"  # Hourly
}

variable "snapshot_start_window" {
  description = "Number of minutes to start the snapshot backup after scheduled time"
  type        = number
  default     = 60
}

variable "snapshot_completion_window" {
  description = "Number of minutes to complete the snapshot backup after starting"
  type        = number
  default     = 180
}

variable "continuous_backup_schedule" {
  description = "Cron expression for continuous backup"
  type        = string
  default     = "cron(0 5 ? * * *)"  # Daily at 5 AM UTC
}

variable "continuous_backup_start_window" {
  description = "Number of minutes to start the continuous backup after scheduled time"
  type        = number
  default     = 60
}

variable "continuous_backup_completion_window" {
  description = "Number of minutes to complete the continuous backup after starting"
  type        = number
  default     = 180
}
