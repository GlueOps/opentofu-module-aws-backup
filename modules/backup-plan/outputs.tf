output "continuous_backup_plan_id" {
  description = "ID of the continuous backup plan"
  value       = aws_backup_plan.continuous.id
}

output "continuous_backup_plan_arn" {
  description = "ARN of the continuous backup plan"
  value       = aws_backup_plan.continuous.arn
}

output "snapshot_backup_plan_id" {
  description = "ID of the snapshot backup plan"
  value       = aws_backup_plan.snapshot.id
}

output "snapshot_backup_plan_arn" {
  description = "ARN of the snapshot backup plan"
  value       = aws_backup_plan.snapshot.arn
}

output "continuous_backup_selection_id" {
  description = "ID of the continuous backup selection"
  value       = aws_backup_selection.continuous.id
}

output "snapshot_backup_selection_id" {
  description = "ID of the snapshot backup selection"
  value       = aws_backup_selection.snapshot.id
}
