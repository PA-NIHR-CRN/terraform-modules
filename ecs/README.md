# Terraform Module: ECS (Elastic Container Service)

This Terraform module allows you to provision an ECS (Elastic Container Service) cluster along with related resources like a security group, CloudWatch log groups, IAM role, and more. It provides flexibility for defining ingress and egress rules and other ECS-related configurations.

## Features

-   Simplifies the setup of ECS infrastructure.
-   Configurable security groups for ingress and egress rules.
-   CloudWatch log group integration for monitoring and logging.
-   Support for Fargate launch type.
-   Ability to configure task definitions and services.


## How to Use This Module

  

> Note that the module will be downloaded over SSH, which will require that you have setup your SSH access credentials, either locally or in the CI pipeline.

### Example

```
module "ecs" {
		source  = "git::git@github.com:PA-NIHR-CRN/terraform-modules/ecs.git?ref=v1.0.0"
		name  =  "example"
		env  =  var.env
		system  =  var.names["system"]
		vpc_id  = var.names["${var.env}"]["vpc"]
		instance_count  = var.names["${var.env}"]["ecs_instance_count"]
		ecs_subnets  =  (var.names["${var.env}"]["ecs_subnet"])
		container_name  =  "${var.names["${var.env}"]["account"]}-system-${var.env}"
		image_url  =  module.example_image.image_uri
		bootstrap_servers  = var.names["${var.env}"]["bootstrap_servers"]
		environment_variables = [
		{
		name = "EXAMPLE1"
		value = "my-example-client-id"
		},
		{
		name = "EXAMPLE2"
		value = "my-example-domain"
		},
		{
		name = "EXAMPLE3"
		value = "https://api.example.com/"
		},
		]
		ecs_cpu  = var.names["${var.env}"]["ecs_cpu"]
		ecs_memory  = var.names["${var.env}"]["ecs_memory"]
		ingress_rules = {
			"http" = {
			from_port = 80
			to_port = 80
			protocol = "TCP"
			cidr_blocks = ["0.0.0.0/0"]
			description = "Allow HTTP traffic"
			}
		}

		egress_rules = {
			"all" = {
			from_port = 0
			to_port = 65535
			protocol = "TCP"
			cidr_blocks = ["0.0.0.0/0"]
			description = "Allow all outbound traffic"
			}
		}
	}
```

Requirements
------------

| Name | Version |
| --- | --- |
| terraform | >= 1.3.0 |
| aws| >= 4.9.0 |

Providers
---------

| Name | Version |
| --- | --- |
| aws | >= 4.9.0 |

## Contributing



## License

This project is licensed under the MIT License - see the LICENSE file for details.