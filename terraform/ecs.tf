resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

resource "aws_cloudwatch_log_group" "service" {
  for_each = local.services

  name              = "/ecs/${var.project_name}/${each.value.name}"
  retention_in_days = 7

  tags = {
    Service = each.value.name
  }
}

resource "aws_ecs_task_definition" "service" {
  for_each = local.services

  family                   = "${var.project_name}-${each.value.name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = each.value.cpu
  memory = each.value.memory

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = each.value.name
      image     = "${aws_ecr_repository.service[each.key].repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = each.value.container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.service[each.key].name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Service = each.value.name
  }
}

resource "aws_ecs_service" "service" {
  for_each = local.services

  name            = "${var.project_name}-${each.value.name}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.service[each.key].arn

  desired_count = var.ecs_desired_count

  launch_type = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]

    security_groups = [
      aws_security_group.ecs.id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service[each.key].arn
    container_name   = each.value.name
    container_port   = each.value.container_port
  }

  tags = {
    Service = each.value.name
  }
}