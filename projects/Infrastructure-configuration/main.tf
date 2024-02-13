terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "http" {
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region_code
}

module "vpc" {
  source      = "./vpc"
  environment = var.environment
  vpc_config = {
    vpc_cidr       = "10.0.0.0/16"
    cidr_allow_all = "0.0.0.0/0"
    azs_count      = 2
  }
}

module "api-gateway" {
  count = var.API_GATEWAY_APP_IMAGE != null ? 1 : 0

  source     = "./service-module"
  depends_on = [module.rabbitmq, module.billing-app, module.inventory-app]

  name           = "api-gateway"
  image          = var.API_GATEWAY_APP_IMAGE
  port           = var.api_gateway_public_port
  environment    = var.environment
  log_group_name = "${var.environment}-app"
  alb = {
    vpc_id = module.vpc.vpc_id
  }

  environment_variables = [
    { name = "RABBITMQ_HOST_ADDRESS", value = "RabbitMQ.${var.environment}-code-keeper" },
    { name = "INVENTORY_HOST", value = "inventory-app.${var.environment}-code-keeper" },
    { name = "API_GATEWAY_PORT", value = var.api_gateway_public_port },
    { name = "RABBITMQ_QUEUE_NAME", value = "billing_queue" },
    { name = "INVENTORY_APP_PORT", value = "8080" },
  ]

  region_code        = var.region_code
  subnet_ids         = module.vpc.subnet_ids
  security_group_ids = module.vpc.security_group_ids

  task_role_arn                  = aws_iam_role.ecs_task_role.arn
  execution_role_arn             = aws_iam_role.ecs_exec_role.arn
  ecs_cluster_id                 = aws_ecs_cluster.ecs_cluster.id
  capacity_provider_name         = aws_ecs_capacity_provider.ecs_capacity_provider.name
  service_discovery_namespace_id = aws_service_discovery_private_dns_namespace.code_keeper.id
}
