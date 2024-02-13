module "rabbitmq" {
  source = "./service-module"

  name           = "RabbitMQ"
  image          = "rabbitmq:3.13.0-rc.2-alpine"
  port           = 5672
  environment    = var.environment
  log_group_name = "${var.environment}-queue"

  environment_variables = [
    { name = "RABBITMQ_QUEUE_NAME", value = "billing_queue" },
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

module "billing-database" {
  count = var.BILLING_DB_IMAGE != null ? 1 : 0

  source = "./service-module"

  name           = "billing-database"
  image          = var.BILLING_DB_IMAGE
  port           = 5432
  environment    = var.environment
  log_group_name = "${var.environment}-database"

  environment_variables = [
    { name = "POSTGRES_DB", value = "orders" },
    { name = "POSTGRES_USER", value = "billing" },
    { name = "POSTGRES_PASSWORD", value = "billing" },
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

module "billing-app" {
  count = var.BILLING_APP_IMAGE != null ? 1 : 0

  source     = "./service-module"
  depends_on = [module.rabbitmq, module.billing-database]

  name           = "billing-app"
  image          = var.BILLING_APP_IMAGE
  environment    = var.environment
  log_group_name = "${var.environment}-app"

  environment_variables = [
    { name = "RABBITMQ_HOST_ADDRESS", value = "RabbitMQ.${var.environment}-code-keeper" },
    { name = "BILLING_DB_HOST", value = "billing-database.${var.environment}-code-keeper" },
    { name = "RABBITMQ_QUEUE_NAME", value = "billing_queue" },
    { name = "BILLING_DB_USER", value = "billing" },
    { name = "BILLING_DB_PASSWORD", value = "billing" },
    { name = "BILLING_DB_NAME", value = "orders" },
    { name = "DATABASE_PORT", value = "5432" },
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
