##
# Here we define that Tags that should exist to be later on attached to resources
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/tag
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/tag_assignment
##

# Local Variables
locals {
  resource_tags = [
    "TF",
    "Legacy",
    "JSF",
    "AMF",
    "JBOSS",
    "ATLASSIAN",
    "OnCall"
  ]
}

# Tags
resource "pagerduty_tag" "custom_tags" {
  for_each = toset(local.resource_tags)
  label    = each.value
}
