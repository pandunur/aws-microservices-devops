variable "aws_region" {
  description = "AWS region where infrastructure will be deployed"
  type        = string
  default     = "ap-southeast-3"
}

variable "project_name" {
  description = "name of the project"
  type        = string
  default     = "ecs-microservices"
}

variable "environment" {
  description = "deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "alb_port" {
  description = "port used by the application load balancer"
  type        = number
  default     = 80
}

variable "container_port" {
  description = "port used by ecs containers"
  type        = number
  default     = 8080
}