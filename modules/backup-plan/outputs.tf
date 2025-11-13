output "backup_plan_id" {
  description = "ID of the backup plan"
  value       = aws_backup_plan.this.id
}

output "backup_plan_arn" {
  description = "ARN of the backup plan"
  value       = aws_backup_plan.this.arn
}

output "backup_selection_id" {
  description = "ID of the backup selection"
  value       = aws_backup_selection.s3.id
}
