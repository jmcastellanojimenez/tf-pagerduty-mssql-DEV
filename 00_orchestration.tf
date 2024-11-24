##
# Here we define the Orchestrations Routes that automate different services Incidents Creation
# This Orchestration feature is replacing the deprecated RuleSets.
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/event_orchestration
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/event_orchestration_router
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/event_orchestration_integration
##

###############################################
#                                             #
#             JBOSS APPLICATIONS              #
#                                             #
###############################################
# Orchestration Event JBOSS PROD
resource "pagerduty_event_orchestration" "maist_orchestration_event" {
  name        = "MAIST Jboss PROD Orchestration"
  description = "MAIST TF Jboss PROD Platform main orchestration event rules"
  team        = pagerduty_team.maist.id
}


resource "pagerduty_event_orchestration_integration" "java_integration_prod" {
  event_orchestration = pagerduty_event_orchestration.maist_orchestration_event.id
  label               = "Integration for Java probes"
}

resource "pagerduty_event_orchestration_integration" "nimbus_integration_prod" {
  event_orchestration = pagerduty_event_orchestration.maist_orchestration_event.id
  label               = "Integration for Nimbus native probes"
}

resource "pagerduty_event_orchestration_router" "main" {

  event_orchestration =  pagerduty_event_orchestration.maist_orchestration_event.id
  set {
    id = "start"


#Rules for Legacy Applications
    dynamic  "rule" {
      for_each = local.apps_prod
      content {

      label = "Route Legacy Application Alerts to the corresponding Service"
      condition {
        expression = "event.custom_details.NimProbeName matches 'JServiceProbe' and event.custom_details.SuppressionKey matches regex 'JSB_\\\\S*_${rule.value.package_id}_${rule.value.install_instance}_\\\\S*'"
      }
      condition {
        expression = "event.custom_details.NimProbeName matches 'JServiceProbe' and event.custom_details.SuppressionKey matches regex 'SERMON_JServiceConfigCheck\\\\S*' and event.summary matches part '${rule.value.package_id}_${rule.value.install_instance}'"
      }
      actions {
        route_to = module.legacy_app[rule.key].id
      }
      } 
    }

}
  catch_all {
    actions {
      route_to = module.legacy_app_prod_catchall.id
    }
  }
}




# Orchestration Event JBOSS NON-PROD
resource "pagerduty_event_orchestration" "maist_orchestration_event_nonprod" {
  name        = "MAIST Jboss NON-PROD Orchestration"
  description = "MAIST TF Jboss NON-PROD Platform main orchestration event rules"
  team        = pagerduty_team.maist.id
}


resource "pagerduty_event_orchestration_integration" "java_integration_nonprod" {
  event_orchestration = pagerduty_event_orchestration.maist_orchestration_event_nonprod.id
  label               = "Integration for Java probes"
}

resource "pagerduty_event_orchestration_integration" "nimbus_integration_nonprod" {
  event_orchestration = pagerduty_event_orchestration.maist_orchestration_event_nonprod.id
  label               = "Integration for Nimbus native probes"
}

resource "pagerduty_event_orchestration_router" "main_nonprod" {

  event_orchestration =  pagerduty_event_orchestration.maist_orchestration_event_nonprod.id
  set {
    id = "start"


#Rules for NON-PROD Legacy Applications
    dynamic  "rule" {
      for_each = local.apps_nonprod
      content {

      label = "Route Legacy Application Alerts to the corresponding Service"
      condition {
        expression = "event.custom_details.NimProbeName matches 'JServiceProbe' and event.custom_details.SuppressionKey matches regex 'JSB_\\\\S*_${rule.value.package_id}_${rule.value.install_instance}_\\\\S*'"
      }
      condition {
        expression = "event.custom_details.NimProbeName matches 'JServiceProbe' and event.custom_details.SuppressionKey matches regex 'SERMON_JServiceConfigCheck\\\\S*' and event.summary matches part '${rule.value.package_id}_${rule.value.install_instance}'"
      }
      actions {
        route_to = module.legacy_app[rule.key].id
      }
      }
    }

}
  catch_all {
    actions {
      route_to = module.legacy_app_nonprod_catchall.id
    }
  }
}



###############################################
#                                             #
#            HTTP INSTANCES                   #
#                                             #
###############################################


# Orchestration Event for PROD HTTP instances
resource "pagerduty_event_orchestration" "maist_orchestration_http_prod" {
  name        = "MAIST HTTP Orchestration PROD"
  description = "MAIST TF HTTP PROD Platform orchestration event rules"
  team        = pagerduty_team.maist.id
}


resource "pagerduty_event_orchestration_integration" "nimbus_integration_http_prod" {
  event_orchestration = pagerduty_event_orchestration.maist_orchestration_http_prod.id
  label               = "Integration for Nimbus native probes"
}

resource "pagerduty_event_orchestration_router" "http_prod" {

  event_orchestration =  pagerduty_event_orchestration.maist_orchestration_http_prod.id
  set {
    id = "start"

#Rules for prod http instances
    dynamic "rule" {
      for_each = local.http_instances_prod
      content {

        label = "Route HTTP PROD instances Alerts to the corresponding Service"
        condition {
          expression = "event.custom_details.NimProbeName matches 'url_response' and event.custom_details.SuppressionKey matches regex '${rule.value.orch_pattern}\\\\S*'"
        }
        actions {
          route_to = module.http_instance[rule.key].id
        }

      }
    }

}
  catch_all {
    actions {
      route_to = module.legacy_http_prod_catchall.id
    }
  }


}


# Orchestration Event for NON-PROD HTTP instances
resource "pagerduty_event_orchestration" "maist_orchestration_http_nonprod" {
  name        = "MAIST HTTP Orchestration NON-PROD"
  description = "MAIST TF HTTP NON-PROD Platform orchestration event rules"
  team        = pagerduty_team.maist.id
}


resource "pagerduty_event_orchestration_integration" "nimbus_integration_http_nonprod" {
  event_orchestration = pagerduty_event_orchestration.maist_orchestration_http_nonprod.id
  label               = "Integration for Nimbus native probes"
}

resource "pagerduty_event_orchestration_router" "http_nonprod" {

  event_orchestration =  pagerduty_event_orchestration.maist_orchestration_http_nonprod.id
  set {
    id = "start"

#Rules for nonprod http instances
    dynamic "rule" {
      for_each = local.http_instances_nonprod
      content {

        label = "Route HTTP NON-PROD instances Alerts to the corresponding Service"
        condition {
          expression = "event.custom_details.NimProbeName matches 'url_response' and event.custom_details.SuppressionKey matches regex '${rule.value.orch_pattern}\\\\S*'"
        }
        actions {
          route_to = module.http_instance[rule.key].id
        }

      }
    }

}
  catch_all {
    actions {
      route_to = module.legacy_http_nonprod_catchall.id
    }
  }


}




###############################################
#                                             #
#              JSF SERVICES                   #
#                                             #
###############################################


# Orchestration for JSF PROD
resource "pagerduty_event_orchestration" "maist_orchestration_jsf_prod" {
  name        = "MAIST JSF PROD Orchestration"
  description = "MAIST TF JSF PROD Platform main orchestration event rules"
  team        = pagerduty_team.maist.id
}


resource "pagerduty_event_orchestration_integration" "java_integration_jsf_prod" {
  event_orchestration = pagerduty_event_orchestration.maist_orchestration_jsf_prod.id
  label               = "Integration for Java probes"
}

resource "pagerduty_event_orchestration_integration" "nimbus_integration_jsf_prod" {
  event_orchestration = pagerduty_event_orchestration.maist_orchestration_jsf_prod.id
  label               = "Integration for Nimbus native probes"
}

resource "pagerduty_event_orchestration_router" "jsf_prod" {

  event_orchestration =  pagerduty_event_orchestration.maist_orchestration_jsf_prod.id
  set {
    id = "start"

#Rules for JSF Services
    dynamic "rule" {
      for_each = local.jsfs_prod
      content {
        label = "Route JSF-Monitor Alerts to the corresponding JSF Service"
        condition {
          expression = "event.custom_details.NimProbeName matches 'JSF-Monitor' and event.custom_details.SuppressionKey matches regex '\\\\S*_JSF_${rule.value.jsf_name}'"
        }
        actions {
          route_to = module.legacy_jsf[rule.key].id
        }
      }
    }


}
  catch_all {
    actions {
      route_to = module.legacy_jsf_prod_catchall.id
    }
  }

}


# Orchestration for JSF NON-PROD
resource "pagerduty_event_orchestration" "maist_orchestration_jsf_nonprod" {
  name        = "MAIST JSF NON-PROD Orchestration"
  description = "MAIST TF JSF NON-PROD Platform main orchestration event rules"
  team        = pagerduty_team.maist.id
}


resource "pagerduty_event_orchestration_integration" "java_integration_jsf_nonprod" {
  event_orchestration = pagerduty_event_orchestration.maist_orchestration_jsf_nonprod.id
  label               = "Integration for Java probes"
}

resource "pagerduty_event_orchestration_integration" "nimbus_integration_jsf_nonprod" {
  event_orchestration = pagerduty_event_orchestration.maist_orchestration_jsf_nonprod.id
  label               = "Integration for Nimbus native probes"
}

resource "pagerduty_event_orchestration_router" "jsf_nonprod" {

  event_orchestration =  pagerduty_event_orchestration.maist_orchestration_jsf_nonprod.id
  set {
    id = "start"

#Rules for JSF Services
    dynamic "rule" {
      for_each = local.jsfs_nonprod
      content {
        label = "Route JSF-Monitor Alerts to the corresponding JSF Service"
        condition {
          expression = "event.custom_details.NimProbeName matches 'JSF-Monitor' and event.custom_details.SuppressionKey matches regex '\\\\S*_JSF_${rule.value.jsf_name}'"
        }
        actions {
          route_to = module.legacy_jsf[rule.key].id
        }
      }
    }


}
  catch_all {
    actions {
      route_to = module.legacy_jsf_nonprod_catchall.id
    }
  }

}



