##
# Here we define Escalation policies and all their general settings
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/escalation_policy
##

resource "pagerduty_escalation_policy" "maist_default" {
  name        = "MAIST OnCall escalation"
  description = "MAIST Platform On-Call Escalation Policy 24/7 Support (only por Production Services)."
  teams       = [pagerduty_team.maist.id]
  num_loops   = 3

  rule {
    escalation_delay_in_minutes = 15
    target {
      type = "schedule_reference"
      id   = data.pagerduty_schedule.maist_oncall.id
    }
  }

  depends_on = [
    data.pagerduty_schedule.maist_oncall
  ]
}

resource "pagerduty_escalation_policy" "maist_nonprod" {
  name        = "MAIST NonProd escalation"
  description = "MAIST Platform Escalation Policy only during Business Hours (07:00-19:00)."
  teams       = [pagerduty_team.maist.id]
  num_loops   = 1

  rule {
    escalation_delay_in_minutes = 30
    target {
      type = "schedule_reference"
      id   = data.pagerduty_schedule.maist_pow.id
    }
  }

  depends_on = [
    data.pagerduty_schedule.maist_oncall,
    data.pagerduty_schedule.maist_pow
  ]
}


#Operators first support level 
resource "pagerduty_escalation_policy" "operators_maist_bridge" {
  name        = "Bridge for MAIST"
  description = "JBOSS Platform Operators Escalation Policy 24/7 Support."
  teams       = [pagerduty_team.maist.id]
  num_loops   = 3

  rule {
    escalation_delay_in_minutes = 15
    target {
      type = "user_reference"
       id = data.pagerduty_user.operators.id
    }
  }

  depends_on = [
    data.pagerduty_user.operators
  ]
}

# To receive incidents and e-mails to MAIST generic.
resource "pagerduty_escalation_policy" "maist_email" {
  name        = "MAIST Email Escalation"
  description = "Escalation for low priority incidents."
  teams       = [pagerduty_team.maist.id]
  num_loops   = 3

  rule {
    escalation_delay_in_minutes = 15
    target {
      type = "user_reference"
       id = data.pagerduty_user.maist.id
    }
  }

  depends_on = [
    data.pagerduty_user.maist
  ]
}


resource "pagerduty_tag_assignment" "maist_np_tf" {
  tag_id      = pagerduty_tag.custom_tags["TF"].id
  entity_type = "escalation_policies"
  entity_id   = pagerduty_escalation_policy.maist_nonprod.id

  depends_on = [
    pagerduty_escalation_policy.maist_nonprod,
    pagerduty_tag.custom_tags
  ]
}

resource "pagerduty_tag_assignment" "maist_p_tf" {
  tag_id      = pagerduty_tag.custom_tags["TF"].id
  entity_type = "escalation_policies"
  entity_id   = pagerduty_escalation_policy.maist_default.id

  depends_on = [
    pagerduty_escalation_policy.maist_default,
    pagerduty_tag.custom_tags
  ]
}

resource "pagerduty_tag_assignment" "bridge_tf" {
  tag_id      = pagerduty_tag.custom_tags["TF"].id
  entity_type = "escalation_policies"
  entity_id   = pagerduty_escalation_policy.operators_maist_bridge.id

  depends_on = [
    pagerduty_escalation_policy.operators_maist_bridge,
    pagerduty_tag.custom_tags
  ]
}

resource "pagerduty_tag_assignment" "maist_email_tf" {
  tag_id      = pagerduty_tag.custom_tags["TF"].id
  entity_type = "escalation_policies"
  entity_id   = pagerduty_escalation_policy.maist_email.id

  depends_on = [
    pagerduty_escalation_policy.maist_email,
    pagerduty_tag.custom_tags
  ]
}

