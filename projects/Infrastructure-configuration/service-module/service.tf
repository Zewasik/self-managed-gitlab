resource "aws_ecs_task_definition" "task_definition" {
  task_role_arn      = var.task_role_arn
  execution_role_arn = var.execution_role_arn
  family             = var.name
  network_mode       = "awsvpc"

  container_definitions = jsonencode([
    {
      name         = var.name
      image        = var.image
      environment  = var.environment_variables
      portMappings = var.port != null ? [{ containerPort = var.port, hostPort = var.port, protocol = "tcp" }] : null
      healthCheck  = var.health_check
      cpu          = 2048
      memory       = 512
      essential    = true

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-region"        = var.region_code
          "awslogs-group"         = "/ecs/${var.log_group_name}"
          "awslogs-stream-prefix" = var.log_group_name
        }
      },
    }
  ])
}

resource "aws_service_discovery_service" "discovery_service" {
  name = aws_ecs_task_definition.task_definition.family

  dns_config {
    namespace_id   = var.service_discovery_namespace_id
    routing_policy = "MULTIVALUE"

    dns_records {
      ttl  = 300
      type = "A"
    }
  }
}

resource "aws_ecs_service" "ecs_service" {
  name                  = var.service_name != null ? var.service_name : "${var.name}-service"
  task_definition       = aws_ecs_task_definition.task_definition.arn
  cluster               = var.ecs_cluster_id
  desired_count         = 1
  wait_for_steady_state = true
  force_new_deployment  = true

  service_registries {
    registry_arn   = aws_service_discovery_service.discovery_service.arn
    container_name = aws_ecs_task_definition.task_definition.family
  }

  dynamic "load_balancer" {
    for_each = var.alb != null ? [aws_lb_target_group.gateway[0].arn] : []
    content {
      target_group_arn = aws_lb_target_group.gateway[0].arn
      container_name   = var.name
      container_port   = aws_lb_target_group.gateway[0].port
    }
  }

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
  }

  placement_constraints {
    type = "distinctInstance"
  }

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = 100
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}
