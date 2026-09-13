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