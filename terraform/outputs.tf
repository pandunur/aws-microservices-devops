output "ecr_repository_urls" {
  description = "ECR repository URLs for all microservices"

  value = {
    for service, repository in aws_ecr_repository.service :
    service => repository.repository_url
  }
}

output "user_ecr_repository_url" {
  value = aws_ecr_repository.service["user"].repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_1_id" {
  value = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  value = aws_subnet.private_2.id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "target_group_arns" {
  value = {
    for service, tg in aws_lb_target_group.service :
    service => tg.arn
  }
}

output "user_target_group_arn" {
  value = aws_lb_target_group.service["user"].arn
}

output "user_log_group_name" {
  value = aws_cloudwatch_log_group.service["user"].name
}

output "cloudwatch_log_groups" {
  value = {
    for service, log_group in aws_cloudwatch_log_group.service :
    service => log_group.name
  }
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}

output "github_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}