output "lambda_sg_id" {
  description = "ID of the Lambda security group"
  value       = aws_security_group.sg_lambda.id
}

output "lambda_invoke_alias_arn" {
  description = "ARN of the Lambda function alias"
  value       = aws_lambda_alias.main.invoke_arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.lambda.function_name
}

output "lambda_alias_name" {
  description = "Name of the Lambda function alias"
  value       = aws_lambda_alias.main.name
}

output "lambda_provisioned_concurrency_config_id" {
  description = "ID of the Lambda provisioned concurrency configuration (if enabled)"
  value       = var.provisioned_concurrent_executions > 0 ? aws_lambda_provisioned_concurrency_config.lambda[0].id : null
}