##
# Here we define Teams and all their general settings
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/team
##

# Teams
## MAIST Operations
resource "pagerduty_team" "maist" {
  name        = "MAIST"
  description = "The Maist Platform Operations Team"
}

## Operators bridge
#resource "pagerduty_team" "operators_bridge" {
#  name        = "BRIDGE"
#  description = "The operations bridge team"
#}





# Apply Required Tags
## MAIST Operations
resource "pagerduty_tag_assignment" "maist_jboss" {
  tag_id      = pagerduty_tag.custom_tags["JBOSS"].id
  entity_type = "teams"
  entity_id   = pagerduty_team.maist.id

  depends_on = [
    pagerduty_team.maist,
    pagerduty_tag.custom_tags
  ]
}
resource "pagerduty_tag_assignment" "maist_tf" {
  tag_id      = pagerduty_tag.custom_tags["TF"].id
  entity_type = "teams"
  entity_id   = pagerduty_team.maist.id

  depends_on = [
    pagerduty_team.maist,
    pagerduty_tag.custom_tags
  ]
}


resource "pagerduty_tag_assignment" "maist_legacy" {
  tag_id      = pagerduty_tag.custom_tags["Legacy"].id
  entity_type = "teams"
  entity_id   = pagerduty_team.maist.id

  depends_on = [
    pagerduty_team.maist,
    pagerduty_tag.custom_tags
  ]
}

resource "pagerduty_tag_assignment" "maist_jsf" {
  tag_id      = pagerduty_tag.custom_tags["JSF"].id
  entity_type = "teams"
  entity_id   = pagerduty_team.maist.id

  depends_on = [
    pagerduty_team.maist,
    pagerduty_tag.custom_tags
  ]
}
