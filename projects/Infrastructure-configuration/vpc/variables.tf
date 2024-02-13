data "aws_availability_zones" "available" { state = "available" }

locals {
  azs = data.aws_availability_zones.available.names
}

variable "environment" {
  type = string
}

variable "vpc_config" {
  type = object({
    vpc_cidr       = string
    cidr_allow_all = string
    azs_count      = number
  })
}
