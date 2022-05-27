locals {
  postfix = var.name_postfix != "" ? var.name_postfix : random_id.id.hex
}

resource "random_id" "id" {
  byte_length = 8
}

resource "cloudfoundry_service_instance" "postgres" {
  name  = "tf-postgres-${local.postfix}"
  space = var.cf_space_id
  //noinspection HILUnresolvedReference
  service_plan                   = data.cloudfoundry_service.rds.service_plans[var.plan]
  replace_on_service_plan_change = var.replace_on_service_plan_change

  json_params = jsonencode({
    "MaxAllocatedStorage" : var.max_allocated_storage
  })
}

resource "cloudfoundry_service_key" "database_key" {
  name             = "key"
  service_instance = cloudfoundry_service_instance.postgres.id
}

resource "cloudfoundry_app" "exporter" {
  name         = "tf-postgres-exporter-${local.postfix}"
  space        = var.cf_space_id
  docker_image = var.exporter_image
  disk_quota   = var.exporter_disk_quota
  memory       = var.exporter_memory
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }
  environment = merge({
    //noinspection HILUnresolvedReference
    DATA_SOURCE_NAME = cloudfoundry_service_key.database_key.credentials.uri
  }, var.exporter_environment)

  //noinspection HCLUnknownBlockType
  routes {
    route = cloudfoundry_route.exporter.id
  }
  labels = {
    "variant.tva/exporter" = true,
  }
  annotations = {
    "prometheus.exporter.type" = "pg_exporter"
    "prometheus.exporter.port" = "3100"
    "prometheus.exporter.path" = "/metrics"
  }
}

resource "cloudfoundry_route" "exporter" {
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = var.cf_space_id
  hostname = "tf-postgres-exporter-${local.postfix}"
}
