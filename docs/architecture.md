# AWS Microservices Architecture

## Overview

This project is a production-inspired microservices architecture built on AWS.

The application consists of three independent services:

- User Service
- Payment Service
- Notification Service

Each service is containerized using Docker and deployed independently using Amazon ECS with AWS Fargate.

Amazon ECR is used as the container image registry, while an Application Load Balancer (ALB) is used as the entry point and routes requests to the appropriate microservice.

---

## Architecture Diagram

---

## AWS Services

| Service | Purpose |
|---|---|
| Amazon VPC | Provides isolated network environment |
| Internet Gateway | Provides Internet connectivity for public subnets |
| Application Load Balancer | Entry point and HTTP path-based routing |
| ECS | Container orchestration |
| AWS Fargate | Runs containers without managing servers |
| Amazon ECR | Stores Docker container images |
| Target Groups | Routes ALB traffic to ECS tasks |
| Security Groups | Controls network access between components |
| NAT Gateway | Provides outbound Internet access from private subnets |

---

## Network Architecture

The application uses a VPC with public and private subnets.

### Public Subnet

The following components are placed in public subnets:

- Internet-facing Application Load Balancer
- NAT Gateway

### Private Subnet

ECS Fargate tasks are deployed in private subnets.

The Fargate tasks do not have public IP addresses and cannot be accessed directly from the Internet.

The intended traffic flow is:

```text
Internet
    |
    | HTTP :80
    v
Application Load Balancer
    |
    | HTTP :8080
    v
ECS Fargate Tasks
Application Routing

The Application Load Balancer uses path-based routing.

The current listener rules are:

/user
    |
    v
user-service Target Group
    |
    v
user-service Fargate :8080


/payment
    |
    v
payment-service Target Group
    |
    v
payment-service Fargate :8080


/notification
    |
    v
notification-service Target Group
    |
    v
notification-service Fargate :8080

Each microservice has its own Target Group.

Security

The ALB Security Group allows inbound HTTP traffic from the Internet:

HTTP :80
Source: 0.0.0.0/0

The ECS Security Group allows application traffic only from the ALB Security Group:

TCP :8080
Source: ALB Security Group

Therefore, users on the Internet cannot directly access the ECS Fargate tasks.

The traffic flow is:

Internet
    |
    | :80
    v
ALB Security Group
    |
    | :8080
    v
ECS Security Group
    |
    v
Fargate Tasks
Container Image Flow

Each microservice is packaged as a Docker image.

The images are pushed to Amazon ECR and then used by ECS Fargate when launching the tasks.

Source Code
    |
    v
Docker Build
    |
    v
Docker Image
    |
    v
Amazon ECR
    |
    v
ECS Fargate
    |
    v
Running Container
Why ECS Fargate?

ECS with Fargate was selected instead of EKS for this project because the current workload does not require Kubernetes-specific capabilities.

Fargate allows containers to run without managing EC2 instances.

This keeps the architecture simpler while still providing:

Container orchestration
Service management
Task deployment
Horizontal scaling capabilities

EKS would be considered when Kubernetes-specific capabilities, an existing Kubernetes platform, or Kubernetes portability are required.

Why Application Load Balancer?

An Application Load Balancer was selected because the architecture requires HTTP-based routing between multiple microservices.

The ALB provides path-based routing so that different requests can be forwarded to different Target Groups.

For example:

/user         -> user-service
/payment      -> payment-service
/notification -> notification-service
