module "inventory-database" {
  count = var.INVENTORY_DB_IMAGE != null ? 1 : 0

  source = "./service-module"

  name           = "inventory-database"
  image          = var.INVENTORY_DB_IMAGE
  port           = 5432
  environment    = var.environment
  log_group_name = "${var.environment}-database"

  environment_variables = [
    { name = "POSTGRES_DB", value = "movies" },
    { name = "POSTGRES_USER", value = "inventory" },
    { name = "POSTGRES_PASSWORD", value = "inventory" },
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

module "inventory-app" {
  count = var.INVENTORY_APP_IMAGE != null ? 1 : 0

  source     = "./service-module"
  depends_on = [module.inventory-database]

  name           = "inventory-app"
  image          = var.INVENTORY_APP_IMAGE
  port           = 8080
  environment    = var.environment
  log_group_name = "${var.environment}-app"

  environment_variables = [
    { name = "INVENTORY_DB_HOST", value = "inventory-database.${var.environment}-code-keeper" },
    { name = "INVENTORY_APP_PORT", value = "8080" },
    { name = "INVENTORY_DB_USER", value = "inventory" },
    { name = "INVENTORY_DB_PASSWORD", value = "inventory" },
    { name = "INVENTORY_DB_NAME", value = "movies" },
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
