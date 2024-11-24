# The local "service" Module
# In this module we create all the standard Services in Pagerduty.
# Here we also set different service orchestration rules based on the Service environment and Service Integrations.
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/service
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/event_orchestration_service
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/data-sources/vendor
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/service_integration
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/slack_connection

## Important:
### - Since this module uses a Slack Channel Integration resource you will need to map your PagerDuty account to a valid Slack Workspace. This can only be done through the PagerDuty UI.
### - This resource requires a PagerDuty user-level API key. This can be set as the user_token on the provider tag or as the PAGERDUTY_USER_TOKEN environment variable.


# Local Variables
locals {
  resolve_timeout_prod     = var.service_environment == "Production" ? "null" : ""
  resolve_timeout_nonprod  = var.service_environment == "Non-Production" ? "1800" : ""
  resolve_timeout_lab      = var.service_environment == "Lab" ? "1800" : ""
  resolve_timeout_catchall = var.service_environment == null ? "1800" : ""
  resolve_timeout          = coalesce(local.resolve_timeout_prod, local.resolve_timeout_nonprod, local.resolve_timeout_lab, local.resolve_timeout_catchall)

##  slack_channel_prod     = var.service_environment == "Production" ? var.slack_channel_alertsprod : ""
##  slack_channel_nonprod  = var.service_environment == "Non-Production" ? var.slack_channel_alertsnonprod : ""
##  slack_channel_lab      = var.service_environment == "Lab" ? var.slack_channel_alertslab : ""
##  slack_channel_catchall = var.service_environment == null ? var.slack_channel_alertscatchall : ""
##  slack_channel          = coalesce(local.slack_channel_prod, local.slack_channel_nonprod, local.slack_channel_lab, local.slack_channel_catchall)

  def_prio_5         = var.service_default_prio == "p5" ? "P5" : ""
  def_prio_4         = var.service_default_prio == "p4" ? "P4" : ""
  def_prio_3         = var.service_default_prio == "p3" ? "P3" : ""
  def_prio_2         = var.service_default_prio == "p2" ? "P2" : ""
  def_prio_1         = var.service_default_prio == "p1" ? "P1" : ""
  def_prio           = coalesce(local.def_prio_5, local.def_prio_4, local.def_prio_3, local.def_prio_2, local.def_prio_1)

  bus_prio_5         = var.service_business_prio == "p5" ? "P5" : ""
  bus_prio_4         = var.service_business_prio == "p4" ? "P4" : ""
  bus_prio_3         = var.service_business_prio == "p3" ? "P3" : ""
  bus_prio_2         = var.service_business_prio == "p2" ? "P2" : ""
  bus_prio_1         = var.service_business_prio == "p1" ? "P1" : ""
  bus_prio           = var.service_business_prio == ""   ? local.def_prio : coalesce(local.bus_prio_5, local.bus_prio_4, local.bus_prio_3, local.bus_prio_2, local.bus_prio_1)

# Load the different service periods assigned to the service into a set
  svc_periods = toset([for pe in var.time_windows : pe ])

# Checks if the calendar is customized
  custom_cal = var.svc_calendar == "" ? "Always" : var.svc_calendar

}


# Grab Required Data


data "pagerduty_priority" "default_prio" {
  name = local.def_prio
}
data "pagerduty_priority" "business_prio" {
  name = local.bus_prio
}

## Priorities
#data "pagerduty_priority" "p1" {
#  name = "P1"
#}
#data "pagerduty_priority" "p2" {
#  name = "P2"
#}
#data "pagerduty_priority" "p3" {
#  name = "P3"
#}
#data "pagerduty_priority" "p4" {
#  name = "P4"
#}
#data "pagerduty_priority" "p5" {
#  name = "P5"
#}

# Technical Service Resource
resource "pagerduty_service" "legacy_app" {
  name                    = var.service_name
  description             = var.service_description
  escalation_policy       = var.service_escalation_policy
  alert_creation          = "create_alerts_and_incidents"
  auto_resolve_timeout    = local.resolve_timeout
  acknowledgement_timeout = "null"


  alert_grouping_parameters {
    type = "intelligent"
    config {
      fields  = []
      timeout = 0
    }
  }
  auto_pause_notifications_parameters {
    enabled = true
    timeout = 300
  }
  incident_urgency_rule {
    type    = "constant"
    urgency = var.service_urgency
  }
}

# Service Orchestration
resource "pagerduty_event_orchestration_service" "nonprod_services" {
  count = var.service_environment == "Production" ? 0 : 1 # Dont create this resource if its environment is Prod

  enable_event_orchestration_for_service = true

  service = pagerduty_service.legacy_app.id
  set {
    id = "start"

    rule {
      label = "Always set 'Warning' Severity for all Non-Prod Incidents"

      actions {
        severity = "warning"
      }
    }
  }

  catch_all {
    actions {}
  }
}

resource "pagerduty_event_orchestration_service" "prod_services" {
  count = var.service_environment == "Production" ? 1 : 0 # Only create this resource if its environment is Prod

  enable_event_orchestration_for_service = true

  service = pagerduty_service.legacy_app.id
  set {

    id = "start"

   dynamic "rule" {
      for_each = local.custom_cal != "Always" ? [1] : []
      content {
        label = "Manage events arriving outside service active window"
        dynamic "condition" {
            for_each = local.svc_periods
            content {
                expression = "${condition.value.condition_str}"
            }
        }        
        actions {
          route_to = "servicedisabled"
        }
      }
   }

   dynamic  "rule" {
      for_each = local.def_prio != local.bus_prio ? [1] : []
      content {
         label = "Split rules  Business - Non-Business hours"

         condition {
            expression = "now in Mon,Tue,Wed,Thu,Fri 07:00:00 to 19:00:00 Europe/Berlin"
         }
         actions {
           annotate = join("",["Business hours special setup to be applied: ","."])
           route_to = "businesshours"
         }

      }
    }


   rule {
     label = join("",["Set default priority for JServiceProbe events to: ",local.def_prio])

     condition { 
       expression = "event.custom_details.NimProbeName matches 'JServiceProbe'"
       }
       actions {
          priority = data.pagerduty_priority.default_prio.id
          annotate = join("",["Set default priority for JServiceProbe events to: ",local.def_prio])
       }
    }
  }

 dynamic  "set" {
    for_each = local.def_prio != local.bus_prio ? [1] : []
    content {

    id = "businesshours"
    rule {
         label = join("",["Set priority for JServiceProbe events during business hours  to: ",local.bus_prio])

         condition {
            expression = "event.custom_details.NimProbeName matches 'JServiceProbe'"
         }
         actions {
            priority = data.pagerduty_priority.business_prio.id
            annotate = join("",["Set priority for JServiceProbe events (Business Hours) to: ",local.bus_prio])
         }
      }
   }
  }

 dynamic  "set" {
    for_each = local.custom_cal != "Always" ? [1] : []
    content {

    id = "servicedisabled"
    rule {
         label = "Discards events arriving outside service active window"

         actions {
           annotate = join("",["Discarded event outside service active window","."])
           suppress = true
         }
      }
   }
  }


  catch_all {
    actions {}
  }

}

#Supports the corresponding infra service.
resource "pagerduty_service_dependency" "legacy_appserver_nonprod_app" {
  count = var.service_environment == "Production" ? 0 : 1 # Dont create this resource if its environment is Prod
  dependency {
    supporting_service {
      id   = pagerduty_service.legacy_app.id
      type = pagerduty_service.legacy_app.type
    }
    dependent_service {
      id = var.legacy_nonprod_bs_id
      type = "business_service"
    }
  }
}
resource "pagerduty_service_dependency" "legacy_appserver_prod_app" {
  count = var.service_environment == "Production" ? 1 : 0 # Create this resource if its environment is Prod
  dependency {
    supporting_service {
      id   = pagerduty_service.legacy_app.id
      type = pagerduty_service.legacy_app.type
    }
    dependent_service {
      id = var.legacy_prod_bs_id
      type = "business_service"
    }
  }
}




# Integrations
# Possible integrations to retrieve information for this service (i.e. SNOW for related changes)

## Slack Connection
#resource "pagerduty_slack_connection" "default_channel" {
#  source_id         = pagerduty_service.legacy_app.id
#  source_type       = "service_reference"
#  workspace_id      = var.slack_epo_workspaceid
#  channel_id        = local.slack_channel
#  notification_type = "responder"
#  config {
#    events = [
#      "incident.triggered",
#      "incident.acknowledged",
#      "incident.unacknowledged",
#      "incident.escalated",
#      "incident.resolved",
#      "incident.reassigned",
#      "incident.annotated",
#      "incident.delegated",
#      "incident.priority_updated",
#      "incident.responder.added",
#      "incident.responder.replied",
#      "incident.status_update_published",
#      "incident.reopened"
#    ]
#  }
#}

