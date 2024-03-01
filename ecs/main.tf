resource "aws_security_group" "ecs_security_group" {
  name        = "${var.account}-sg-${var.env}-ecs-${var.name}"
  description = "ECS Security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      security_groups = ingress.value.security_groups
      description     = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = {
    Name        = "${var.account}-sg-${var.env}-ecs-${var.name}",
    Environment = var.env,
    System      = var.name,
  }

}

resource "aws_cloudwatch_log_group" "cluster" {
  name       = "${var.account}-ecs-${var.env}-${var.name}-loggroup"
  kms_key_id = var.kms_key_id
  tags = {
    Name        = "${var.account}-ecs-cloudwatch-${var.env}-${var.name}-loggroup",
    Environment = var.env,
    System      = var.name,
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.account}-ecs-${var.env}-${var.name}-cluster"

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.cluster.name
      }
    }
  }

  tags = {
    Name        = "${var.account}-ecs-cloudwatch-${var.env}-${var.name}-loggroup",
    Environment = var.env,
    System      = var.name,
  }
}

resource "aws_cloudwatch_log_group" "ecs_task_log_group" {
  name       = "${var.account}-ecs-taskdefinition-${var.env}-${var.name}-loggroup"
  kms_key_id = var.kms_key_id
  tags = {
    Name        = "${var.account}-ecs-taskdefinition-${var.env}-${var.name}-loggroup",
    Environment = var.env,
    System      = var.name,
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.account}-ecs-${var.env}-${var.name}-task-definition"
  requires_compatibilities = var.task_definition_requires_compatibilities
  network_mode             = var.task_definition_network_mode
  execution_role_arn       = aws_iam_role.iam-ecs-task-role.arn
  task_role_arn            = aws_iam_role.iam-ecs-task-role.arn
  memory                   = var.ecs_memory
  cpu                      = var.ecs_cpu
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.image_url
      essential = true
      memory    = var.ecs_memory
      cpu       = var.ecs_cpu
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_task_log_group.name,
          "awslogs-region"        = var.region,
          "awslogs-stream-prefix" = "ecs"
        }
      }
      portMappings = [
        {
          protocol      = var.target_protocol
          containerPort = var.target_port
          hostPort      = var.target_port
        }
      ]
      secrets     = var.ecs_secrets
      environment = var.environment_variables
    }
  ])

  tags = {
    Name        = "${var.account}-ecs-${var.env}-${var.name}-task-definition",
    Environment = var.env,
    System      = var.name,
  }
}

resource "aws_ecs_service" "ecs_service" {
  name                  = "${var.account}-ecs-service-${var.env}-${var.name}"
  cluster               = aws_ecs_cluster.ecs_cluster.id
  task_definition       = aws_ecs_task_definition.ecs_task_definition.arn
  launch_type           = "FARGATE"
  desired_count         = var.ecs_service_desired_count
  force_new_deployment  = var.ecs_service_force_new_deployment
  wait_for_steady_state = var.ecs_service_wait_for_steady_state

  network_configuration {
    security_groups  = [aws_security_group.ecs_security_group.id]
    subnets          = var.ecs_subnets
    assign_public_ip = var.assign_public_ip
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_count]
  }

  tags = {
    Name        = "${var.account}-ecs-service-${var.env}-${var.name}",
    Environment = var.env,
    System      = var.name,
  }

}
