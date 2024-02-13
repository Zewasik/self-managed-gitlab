resource "aws_service_discovery_private_dns_namespace" "code_keeper" {
  name = "${var.environment}-code-keeper"
  vpc  = module.vpc.vpc_id
}
