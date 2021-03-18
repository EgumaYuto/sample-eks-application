
##########
# Cluster
##########
resource "aws_ecs_cluster" "cluster" {
  name = "${local.name}-cluster"
}

##################
# Task Definition
##################
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
  name               = "${local.name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "execution_policy_attachment" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name               = "${local.name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_policy.json
}

resource "aws_ecs_task_definition" "dummy_definition" {
  family       = local.name
  network_mode = "awsvpc"

  execution_role_arn = aws_iam_role.execution_role.arn
  task_role_arn      = aws_iam_role.task_role.arn

  cpu                      = "512"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]

  container_definitions = <<EOF
[
  {
    "image": "${aws_ecr_repository.ecr.repository_url}:latest",
    "cpu": 512,
    "memory": 1024,
    "networkMode": "awsvpc",
    "name": "${local.name}",
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

##########
# Service
##########
resource "aws_security_group" "ecs_sg" {
  name        = "${local.name}-ecs-instance"
  description = "${local.name} ecs instance"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "service" {
  name            = local.name
  cluster         = aws_ecs_cluster.cluster.name
  task_definition = aws_ecs_task_definition.dummy_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_alb_target_group.target_group.arn
    container_name   = local.name
    container_port   = 8080
  }

  network_configuration {
    subnets          = [for subnet in aws_subnet.private : subnet.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }
}

