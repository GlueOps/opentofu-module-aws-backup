variable "tenant_key" {
  description = "The tenant identifier used for naming and tagging resources"
  type        = string
  nullable    = false
}

variable "regions" {
  description = "List of AWS regions where backup vaults will be created"
  type        = list(string)
  nullable    = false
  
  validation {
    condition     = length(var.regions) > 0
    error_message = "At least one region must be specified."
  }
}

variable "assume_role_arn" {
  description = "Optional IAM role ARN to assume for AWS API calls. If not provided, uses default credentials."
  type        = string
  default     = null
}

variable "backup_retention_days" {
  description = "Number of days to retain backups in the primary vault"
  type        = number
  default     = 7
}

variable "continuous_backup_retention_days" {
  description = "Number of days to retain continuous backups (max 35 days for AWS Backup continuous backups)"
  type        = number
  default     = 35
  
  validation {
    condition     = var.continuous_backup_retention_days >= 1 && var.continuous_backup_retention_days <= 35
    error_message = "Continuous backup retention must be between 1 and 35 days."
  }
}

# Snapshot backup settings
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

# Continuous backup settings
variable "continuous_backup_schedule" {
  description = "Cron expression for continuous backup (AWS default for continuous backup)"
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

# Vault lock settings
variable "vault_lock_changeable_days" {
  description = "Number of days the vault lock can be changed before becoming immutable. Set to 0 to make it immediately immutable."
  type        = number
  default     = 365  # Long window for flexibility
}

variable "vault_lock_min_retention_days" {
  description = "Minimum number of days backups must be retained (compliance requirement)"
  type        = number
  default     = 1
}

variable "vault_lock_max_retention_days" {
  description = "Maximum number of days backups can be retained (compliance requirement)"
  type        = number
  default     = 120  # Short max retention by default
}

variable "enable_vault_lock" {
  description = "Enable vault lock (compliance mode) to prevent backup deletion. Enabled by default for data protection."
  type        = bool
  default     = true
}