# AWS Microservices DevOps Project

A hands-on, production-inspired microservices architecture built on AWS using Docker, Amazon ECR, ECS Fargate, and Application Load Balancer.

## Architecture

![AWS Microservices Architecture](diagrams/aws-microservices-architecture.png)

## Architecture Overview

The application consists of three independent microservices:

- User Service
- Payment Service
- Notification Service

Each service is containerized with Docker and deployed independently using ECS Fargate.

The services run in private subnets and are accessed through an internet-facing Application Load Balancer.

### Request Flow

```text
Internet
    |
    v
ALB :80
    |
    +-- /user ---------> user-service :8080
    |
    +-- /payment ------> payment-service :8080
    |
    +-- /notification -> notification-service :8080
