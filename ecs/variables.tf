# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "env" {
  description = "Environment name"
  type        = string

  validation {
    condition     = var.env == "dev" || var.env == "test" || var.env == "uat" || var.env == "oat" || var.env == "prod"
    error_message = "The Env value must be \"dev\" OR \"oat\" OR \"uat\" OR \"prod\"."
  }
}
variable "name" {
  type = string
}

variable "account" {
  description = "Account name"
  type        = string
  default     = "nihrd"
}

variable "image_url" {
  description = "Container image url"
  type        = string
}

variable "container_name" {
  description = "Name of Container"
  type        = string
}

variable "kms_key_id" {
  description = "The ARN of the KMS key to use for encrypting CloudWatch logs."
  type        = string
}

variable "ecs_secrets" {
  description = "List of secrets for the container."
  type        = list(map(string))
}


variable "environment_variables" {
  description = "List of environment variables for the container."
  type        = list(map(string))
}

variable "ingress_rules" {
  description = "Map of ingress rules for the ECS security group"
  type        = map(any)
}

variable "egress_rules" {
  description = "Map of egress rules for the ECS security group"
  type        = map(any)
}

variable "path_pattern_values" {
  description = "List of values for the path pattern condition"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC id for ECS"
  type        = string
}

variable "ecs_subnets" {
  description = "List of subnets for ecs"
  type        = list(any)
}

variable "region" {
  default     = "eu-west-2"
  type        = string
  description = "AWS Region"
}

variable "ecs_memory" {
  description = "ECS Memory size"
  type        = number
  default     = 512
}

variable "ecs_cpu" {
  description = "ECS CPU size"
  type        = number
  default     = 256
}

variable "ecs_service_desired_count" {
  description = "The maximum number of containers in the ASG"
  type        = number
  default     = 1
}

variable "ecs_service_force_new_deployment" {
  description = "The maximum number of containers in the ASG"
  type        = bool
  default     = true
}

variable "ecs_service_wait_for_steady_state" {
  description = "The maximum number of containers in the ASG"
  type        = bool
  default     = true
}

variable "autoscaling_policy_target_value" {
  description = "The maximum number of containers in the ASG"
  type        = number
  default     = 10 * 60 # 10 reqs/s
}

variable "task_definition_requires_compatibilities" {
  description = "List of launch types compatible with the task definition"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "task_definition_network_mode" {
  description = "The network mode for the task definition"
  type        = string
  default     = "awsvpc"
}

variable "enable_container_insights" {
  type        = bool
  default     = true
  description = "Enable Cloudwatch Container Insights"
}

variable "target_port" {
  description = "Port number for the target group."
  type        = number
  default     = 8080
}

variable "target_protocol" {
  description = "Protocol for the target group."
  type        = string
  default     = "TCP"
}

variable "assign_public_ip" {
  type        = bool
  default     = false
  description = "Assign public IP to ECS Service"
}
