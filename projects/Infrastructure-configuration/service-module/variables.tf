variable "environment" {
  type = string
}

variable "image" {
  type = string
}

variable "name" {
  type = string
}

variable "port" {
  type    = number
  default = null
}

variable "region_code" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "capacity_provider_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "ecs_cluster_id" {
  type = string
}

variable "service_discovery_namespace_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "log_group_name" {
  type = string
}

variable "alb" {
  type = object({
    vpc_id              = string
    health_check_port   = optional(number)
    health_check_path   = optional(string)
    enable_health_check = optional(bool)
  })
  default = null
}

variable "service_name" {
  type    = string
  default = null
}

variable "environment_variables" {
  type    = list(object({ name = string, value = string }))
  default = []
}

variable "health_check" {
  type = object({
    command  = list(string)
    interval = number
    timeout  = number
    retries  = number
  })
  default = null
}
