variable "name_prefix" {
  description = "Prefix to use for resource names"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "system" {
  description = "System name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the Lambda function will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the Lambda function will be deployed"
  type        = list(string)
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda function can use at runtime"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Amount of time your Lambda function has to run in seconds"
  type        = number
  default     = 60
}

variable "handler" {
  description = "Function entrypoint in your code"
  type        = string
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda function version"
  type        = bool
  default     = true
}

variable "filename" {
  description = "Path to the function's deployment package within the local filesystem"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role for the Lambda function"
  type        = string
}

variable "runtime" {
  description = "Identifier of the function's runtime"
  type        = string
}

variable "environment_variables" {
  description = "Map of environment variables that are accessible from the function code during execution"
  type        = map(string)
  default     = {}
}

variable "lifecycle_ignore_changes" {
  description = "List of attributes to ignore changes for"
  type        = list(string)
  default     = null
}

variable "alias_name" {
  description = "Name for the Lambda function alias"
  type        = string
  default     = "main"
}

variable "log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the CloudWatch log group"
  type        = number
  default     = 14
}

variable "provisioned_concurrent_executions" {
  description = "Amount of provisioned concurrent executions for the Lambda function. Set to 0 to disable."
  type        = number
  default     = 0
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}