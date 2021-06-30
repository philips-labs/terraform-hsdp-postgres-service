output "service_id" {
  description = "The service id"
  value       = cloudfoundry_service_instance.postgres.id
}
