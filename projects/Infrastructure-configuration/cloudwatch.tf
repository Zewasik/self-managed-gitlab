resource "aws_cloudwatch_log_group" "app_group" {
  name              = "/ecs/${var.environment}-app"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "database_group" {
  name              = "/ecs/${var.environment}-database"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "queue_group" {
  name              = "/ecs/${var.environment}-queue"
  retention_in_days = 14
}
