resource "aws_security_group" "sg_lambda" {
  name        = "${var.name_prefix}-sg-lambda-${var.env}-${var.system}"
  description = "Lambda security group"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-sg-lambda-${var.env}-${var.system}"
    Environment = var.env
    System      = var.system
  })
}

resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  memory_size   = var.memory_size
  timeout       = var.timeout
  handler       = var.handler
  publish       = var.publish
  filename      = var.filename
  role          = var.lambda_role_arn
  runtime       = var.runtime

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.sg_lambda.id]
  }

  environment {
    variables = var.environment_variables
  }

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-lambda-${var.env}-${var.system}"
    Environment = var.env
    System      = var.system
  })
}

resource "aws_lambda_provisioned_concurrency_config" "lambda" {
  count                             = var.provisioned_concurrent_executions > 0 ? 1 : 0
  function_name                     = aws_lambda_function.lambda.function_name
  provisioned_concurrent_executions = var.provisioned_concurrent_executions
  qualifier                         = aws_lambda_alias.main.name
}

resource "aws_lambda_alias" "main" {
  name             = var.alias_name
  function_name    = aws_lambda_function.lambda.function_name
  function_version = aws_lambda_function.lambda.version
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.log_retention_in_days

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-lambda-${var.env}-${var.system}"
    Environment = var.env
    System      = var.system
  })
}