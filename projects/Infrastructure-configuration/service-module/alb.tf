resource "aws_lb" "main" {
  count              = var.alb != null ? 1 : 0
  name               = "${var.environment}-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids
}

resource "aws_lb_target_group" "gateway" {
  count       = var.alb != null ? 1 : 0
  vpc_id      = var.alb.vpc_id
  protocol    = "HTTP"
  port        = var.port
  target_type = "ip"

  health_check {
    enabled             = var.alb.enable_health_check
    path                = var.alb.health_check_path != null ? var.alb.health_check_path : "/"
    port                = var.alb.health_check_port != null ? var.alb.health_check_port : var.port
    matcher             = 200
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "lb_listener" {
  count             = var.alb != null ? 1 : 0
  load_balancer_arn = aws_lb.main[0].id
  port              = aws_lb_target_group.gateway[0].port
  protocol          = aws_lb_target_group.gateway[0].protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gateway[0].id
  }
}

output "alb_url" {
  value = var.alb != null ? aws_lb.main[0].dns_name : null
}
