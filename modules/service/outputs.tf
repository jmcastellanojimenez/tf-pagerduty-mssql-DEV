##
# The local module "service" outputs
##

output "id" {
  description = "ID of the Service"
  value       = pagerduty_service.legacy_app.id
}

output "type" {
  description = "Type of the Service"
  value       = pagerduty_service.legacy_app.type
}

output "name" {
  description = "Name of the Service"
  value       = pagerduty_service.legacy_app.name
}

