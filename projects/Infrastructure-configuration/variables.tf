variable "environment" {
  type    = string
  default = null
}

variable "region_code" {
  description = "Value of the app region"
  default     = "eu-north-1"
}

variable "api_gateway_public_port" {
  default = 3000
}

variable "API_GATEWAY_APP_IMAGE" {
  type    = string
  default = null
}

variable "INVENTORY_APP_IMAGE" {
  type    = string
  default = null
}

variable "INVENTORY_DB_IMAGE" {
  type    = string
  default = null
}

variable "BILLING_APP_IMAGE" {
  type    = string
  default = null
}

variable "BILLING_DB_IMAGE" {
  type    = string
  default = null
}
