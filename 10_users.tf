##
# Here we define Users that should exist to be mapped into Teams
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/user
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/team_membership
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/user_contact_method
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/user_notification_rule
##

# Roles mappings can be found here: 
## https://support.pagerduty.com/docs/advanced-permissions#roles-in-the-rest-api-and-saml

# Important:
## Currently creating Users is not working properly since we can't define the License to be used
## https://github.com/PagerDuty/terraform-provider-pagerduty/issues/631
## Therefore Users must be manually created first in the UI then Imported in Terraform
####  $ terraform import pagerduty_user.RESOURCE_NAME USER_ID

# Users

## OPERATORS GENERIC USER
data "pagerduty_user" "operators" {
  email = "operators@epo.org"
}



## MAIST GENERIC USER
data "pagerduty_user" "maist" {
  email = "maist@epo.org"
}
resource "pagerduty_team_membership" "maist_maist" {
  user_id = data.pagerduty_user.maist.id
  team_id = pagerduty_team.maist.id
  role    = "observer"

  depends_on = [
    pagerduty_team.maist,
    data.pagerduty_user.maist
  ]
}




## 
data "pagerduty_user" "pvt" {
  email = "pvillanuevatosquella.external@epo.org"
}
### Team Mappings
resource "pagerduty_team_membership" "pvt_maist" {
  user_id = data.pagerduty_user.pvt.id
  team_id = pagerduty_team.maist.id
  role    = "manager"

  depends_on = [
    pagerduty_team.maist
  ]
}

## 
data "pagerduty_user" "jribeiro" {
  email = "jribeiro.external@epo.org"
}
resource "pagerduty_team_membership" "jribeiro_maist" {
  user_id = data.pagerduty_user.jribeiro.id
  team_id = pagerduty_team.maist.id
  role    = "responder"

  depends_on = [
    pagerduty_team.maist
  ]
}


## 
data "pagerduty_user" "jonas" {
  email = "jsanchezfuertes.external@epo.org"
}
resource "pagerduty_team_membership" "jonas_maist" {
  user_id = data.pagerduty_user.jonas.id
  team_id = pagerduty_team.maist.id
  role    = "responder"

  depends_on = [
    pagerduty_team.maist
  ]
}

## 
data "pagerduty_user" "mribeiro" {
  email = "mribeiro.external@epo.org"
}
resource "pagerduty_team_membership" "mribeiro_maist" {
  user_id = data.pagerduty_user.mribeiro.id
  team_id = pagerduty_team.maist.id
  role    = "responder"

  depends_on = [
    pagerduty_team.maist
  ]
}

## 
data "pagerduty_user" "calmansa" {
  email = "calmansaalmansa.external@epo.org"
}
resource "pagerduty_team_membership" "calmansa_maist" {
  user_id = data.pagerduty_user.calmansa.id
  team_id = pagerduty_team.maist.id
  role    = "responder"

  depends_on = [
    pagerduty_team.maist
  ]
}

## 
data "pagerduty_user" "mgarcia" {
  email = "mgarciaortega.external@epo.org"
}
resource "pagerduty_team_membership" "mgarcia_maist" {
  user_id = data.pagerduty_user.mgarcia.id
  team_id = pagerduty_team.maist.id
  role    = "manager"

  depends_on = [
    pagerduty_team.maist
  ]
}

