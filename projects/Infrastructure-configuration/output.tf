output "documentation_url" {
  value = var.API_GATEWAY_APP_IMAGE != null ? "${module.api-gateway[0].alb_url}:${var.api_gateway_public_port}/api-docs" : null
}
