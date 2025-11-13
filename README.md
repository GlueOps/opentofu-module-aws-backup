<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backup_plan"></a> [backup\_plan](#module\_backup\_plan) | ./modules/backup-plan | n/a |
| <a name="module_vault"></a> [vault](#module\_vault) | ./modules/vault | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | Optional IAM role ARN to assume for AWS API calls. If not provided, uses default credentials. | `string` | `null` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Number of days to retain backups in the primary vault | `number` | `7` | no |
| <a name="input_continuous_backup_completion_window"></a> [continuous\_backup\_completion\_window](#input\_continuous\_backup\_completion\_window) | Number of minutes to complete the continuous backup after starting | `number` | `180` | no |
| <a name="input_continuous_backup_retention_days"></a> [continuous\_backup\_retention\_days](#input\_continuous\_backup\_retention\_days) | Number of days to retain continuous backups (max 35 days for AWS Backup continuous backups) | `number` | `35` | no |
| <a name="input_continuous_backup_schedule"></a> [continuous\_backup\_schedule](#input\_continuous\_backup\_schedule) | Cron expression for continuous backup (AWS default for continuous backup) | `string` | `"cron(0 5 ? * * *)"` | no |
| <a name="input_continuous_backup_start_window"></a> [continuous\_backup\_start\_window](#input\_continuous\_backup\_start\_window) | Number of minutes to start the continuous backup after scheduled time | `number` | `60` | no |
| <a name="input_enable_vault_lock"></a> [enable\_vault\_lock](#input\_enable\_vault\_lock) | Enable vault lock (compliance mode) to prevent backup deletion. Enabled by default for data protection. | `bool` | `true` | no |
| <a name="input_regions"></a> [regions](#input\_regions) | List of AWS regions where backup vaults will be created | `list(string)` | n/a | yes |
| <a name="input_snapshot_completion_window"></a> [snapshot\_completion\_window](#input\_snapshot\_completion\_window) | Number of minutes to complete the snapshot backup after starting | `number` | `180` | no |
| <a name="input_snapshot_schedule"></a> [snapshot\_schedule](#input\_snapshot\_schedule) | Cron expression for snapshot backup schedule | `string` | `"cron(0 * * * ? *)"` | no |
| <a name="input_snapshot_start_window"></a> [snapshot\_start\_window](#input\_snapshot\_start\_window) | Number of minutes to start the snapshot backup after scheduled time | `number` | `60` | no |
| <a name="input_tenant_key"></a> [tenant\_key](#input\_tenant\_key) | The tenant identifier used for naming and tagging resources | `string` | n/a | yes |
| <a name="input_vault_lock_changeable_days"></a> [vault\_lock\_changeable\_days](#input\_vault\_lock\_changeable\_days) | Number of days the vault lock can be changed before becoming immutable. Set to 0 to make it immediately immutable. | `number` | `365` | no |
| <a name="input_vault_lock_max_retention_days"></a> [vault\_lock\_max\_retention\_days](#input\_vault\_lock\_max\_retention\_days) | Maximum number of days backups can be retained (compliance requirement) | `number` | `120` | no |
| <a name="input_vault_lock_min_retention_days"></a> [vault\_lock\_min\_retention\_days](#input\_vault\_lock\_min\_retention\_days) | Minimum number of days backups must be retained (compliance requirement) | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_plan_arns"></a> [backup\_plan\_arns](#output\_backup\_plan\_arns) | Map of region to backup plan ARN |
| <a name="output_backup_plan_ids"></a> [backup\_plan\_ids](#output\_backup\_plan\_ids) | Map of region to backup plan ID |
| <a name="output_backup_vault_arns"></a> [backup\_vault\_arns](#output\_backup\_vault\_arns) | Map of region to backup vault ARN |
| <a name="output_backup_vault_ids"></a> [backup\_vault\_ids](#output\_backup\_vault\_ids) | Map of region to backup vault ID |
<!-- END_TF_DOCS -->
