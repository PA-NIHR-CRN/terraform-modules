AWS Lambda Function Terraform Module
====================================

Deploys an AWS Lambda function with associated resources including a security group, CloudWatch log group, and optional provisioned concurrency.

Usage
-----

```
module "lambda_function" {
  source = "github.com/PA-NIHR-CRN/terraform-modules//ecr?ref=v1.0.0"
  name_prefix    = "myapp"
  env            = "prod"
  system         = "api"
  vpc_id         = "vpc-1234567890abcdef0"
  subnet_ids     = ["subnet-1234567890abcdef0", "subnet-0987654321fedcba0"]
  handler        = "index.handler"
  filename       = "./lambda_function.zip"
  lambda_role_arn = "arn:aws:iam::123456789012:role/lambda-execution-role"
  runtime        = "dotnet6"

  environment_variables = {
    NODE_ENV            = "production"
    DATABASE_URL        = "https://mydb.example.com"
    "MessageBus__Topic" = var.message_bus_topic,
  }

  provisioned_concurrent_executions = 2  # Set to 0 to disable

  tags = {
    Environment = "prod"
    Project     = "MyApp"
    Name        = "Function Name"
  }
}
```

Requirements
------------

-   Terraform >= 0.12.26
-   AWS provider >= 3.0

Inputs
------

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| name_prefix | Prefix for resource names | `string` | n/a | yes |
| env | Environment name | `string` | n/a | yes |
| system | System name | `string` | n/a | yes |
| vpc_id | VPC ID for Lambda deployment | `string` | n/a | yes |
| subnet_ids | Subnet IDs for Lambda deployment | `list(string)` | n/a | yes |
| handler | Function entrypoint in your code | `string` | n/a | yes |
| filename | Path to the Lambda deployment package | `string` | n/a | yes |
| lambda_role_arn | ARN of the Lambda IAM role | `string` | n/a | yes |
| runtime | Lambda runtime identifier | `string` | n/a | yes |
| memory_size | Lambda function memory size (MB) | `number` | `128` | no |
| timeout | Lambda function timeout (seconds) | `number` | `60` | no |
| environment_variables | Environment variables for the Lambda function | `map(string)` | `{}` | no |
| provisioned_concurrent_executions | Provisioned concurrent executions (0 to disable) | `number` | `0` | no |
| tags | Tags for all resources | `map(string)` | `{}` | no |

Outputs
-------

| Name | Description |
| --- | --- |
| lambda_sg_id | ID of the Lambda security group |
| lambda_invoke_alias_arn | ARN of the Lambda function alias |
| lambda_function_name | Name of the Lambda function |
| lambda_alias_name | Name of the Lambda function alias |

Notes
-----

-   Replace the source URL with your actual module repository.
-   Ensure the specified IAM role has necessary permissions.
-   Adjust VPC and subnet IDs to match your infrastructure.