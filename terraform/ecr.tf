locals {
  services = {
    user = {
      name           = "user-service"
      container_port = 8080
      cpu            = 256
      memory         = 512
    }

    payment = {
      name           = "payment-service"
      container_port = 8080
      cpu            = 256
      memory         = 512
    }

    notification = {
      name           = "notification-service"
      container_port = 8080
      cpu            = 256
      memory         = 512
    }
  }
}

resource "aws_ecr_repository" "service" {
  for_each = local.services

  name = "${var.project_name}-${each.value.name}"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Service = each.value.name
  }
}