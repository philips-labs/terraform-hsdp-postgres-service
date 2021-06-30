output "service_id" {
  description = "The service id"
  value       = cloudfoundry_service_instance.postgres.id
}

output "credentials" {
  description = "The service credentials"
  sensitive   = true
  value       = cloudfoundry_service_key.database_key.credentials
}