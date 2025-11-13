variable "tenant_key" {
  description = "Unique identifier for the tenant"
  type        = string
}

variable "region" {
  description = "AWS region for this vault"
  type        = string
}

variable "enable_vault_lock" {
  description = "Enable vault lock (compliance mode) to prevent backup deletion"
  type        = bool
  default     = true
}

variable "vault_lock_changeable_days" {
  description = "Number of days the vault lock can be changed before becoming immutable"
  type        = number
  default     = 365
}

variable "vault_lock_min_retention_days" {
  description = "Minimum number of days backups must be retained"
  type        = number
  default     = 1
}

variable "vault_lock_max_retention_days" {
  description = "Maximum number of days backups can be retained"
  type        = number
  default     = 7
}
