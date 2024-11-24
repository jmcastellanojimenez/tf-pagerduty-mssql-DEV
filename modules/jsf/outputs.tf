##
# The local module "service" outputs
##

output "id" {
  description = "ID of the Service"
  value       = pagerduty_service.legacy_jsf.id
}

output "type" {
  description = "Type of the Service"
  value       = pagerduty_service.legacy_jsf.type
}

output "name" {
  description = "Name of the Service"
  value       = pagerduty_service.legacy_jsf.name
}

