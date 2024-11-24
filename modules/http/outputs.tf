##
# The local module "http" outputs
##

output "id" {
  description = "ID of the Service"
  value       = pagerduty_service.http_instance.id
}

output "type" {
  description = "Type of the Service"
  value       = pagerduty_service.http_instance.type
}

output "name" {
  description = "Name of the Service"
  value       = pagerduty_service.http_instance.name
}

