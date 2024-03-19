resource "aws_iam_role" "iam-ecs-task-role" {
  name = "${var.account}-iam-${var.env}-${var.name}-ecs-iam-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": ["ecs-tasks.amazonaws.com", "ecs.amazonaws.com"]
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  tags = {
    Name        = "${var.account}-iam-${var.env}-${var.name}-ecs-iam-role",
    Environment = var.env,
    System      = var.name,
  }
}

resource "aws_iam_role_policy" "task-execution-role-policy" {
  name = "${var.account}-iam-policy-${var.env}-${var.name}-ecs-task-definition"
  role = aws_iam_role.iam-ecs-task-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:Get*",
          "ecr:Describe*",
          "ecr:List*",
          "kms:List*",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "xray:Get*",
          "xray:PutTelemetryRecords",
          "xray:PutTraceSegments",
          "lambda:InvokeFunction",
          "sqs:ReceiveMessage",
          "kafka:*",
          "s3:*",
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyPair",
          "kms:ReEncryptFrom",
          "kms:ReEncryptTo"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
