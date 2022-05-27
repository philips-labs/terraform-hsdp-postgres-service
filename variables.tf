variable "cf_space_id" {
  description = "Cloudfoundry space id to provision resources in"
  type        = string
}

variable "name_postfix" {
  type        = string
  description = "The postfix string to append to the space, hostname, etc. Prevents namespace clashes"
  default     = ""
}

variable "exporter_image" {
  description = "Image to use for Redis exporter"
  default     = "quay.io/prometheuscommunity/postgres-exporter:latest"
  type        = string
}

variable "docker_username" {
  description = "Docker username to use"
  type        = string
  default     = ""
}

variable "docker_password" {
  description = "Docker password to use"
  type        = string
  default     = ""
}

variable "plan" {
  description = "Plan to use"
  type        = string
  default     = "postgres-micro-dev"
}

variable "exporter_memory" {
  type        = number
  description = "Exporter memory settings"
  default     = 64
}

variable "exporter_disk_quota" {
  type        = number
  description = "Exporter disk quota"
  default     = 1024
}

variable "exporter_environment" {
  type        = map(any)
  description = "Additional configuration for the exporter"
  default     = {}
}

variable "replace_on_service_plan_change" {
  type        = bool
  description = "Replaces the instance in case of service plan change. Does not preserve data!"
  default     = false
}

variable "max_allocated_storage" {
  type        = number
  description = "Sets the maximum storage size (in GB). Enables autoscaling"
  default     = 100
}
