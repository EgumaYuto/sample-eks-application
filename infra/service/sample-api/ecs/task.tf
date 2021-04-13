data "aws_iam_policy_document" "task_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "execution_role" {
  name               = "${module.naming.name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "execution_policy_attachment" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name               = "${module.naming.name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_policy.json
}

resource "aws_ecs_task_definition" "dummy_definition" {
  family       = module.naming.name
  network_mode = "awsvpc"

  execution_role_arn = aws_iam_role.execution_role.arn
  task_role_arn      = aws_iam_role.task_role.arn

  cpu                      = "512"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]

  container_definitions = <<EOF
[
  {
    "image": "${local.repository_url}:latest",
    "cpu": 512,
    "memory": 1024,
    "networkMode": "awsvpc",
    "name": "${module.naming.name}",
    "portMappings": [
      {
        "containerPort": 8080,
        "protocol": "tcp"
      }
    ]
  }
]
EOF
}