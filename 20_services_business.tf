##
# Here we define Business Services and all their general settings
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/business_service
##

# Business Services
## JBOSS/Legacy Platform
resource "pagerduty_business_service" "legacy_platform" {
  name        = "Legacy Platform"
  description = "JBOSS-Legacy Platform"
  team        = pagerduty_team.maist.id
}

## Legacy Environments
resource "pagerduty_business_service" "legacy_infra_prod" {
  name        = "Legacy Prod"
  description = "JBOSS-Legacy Production Infrastructure"
  team        = pagerduty_team.maist.id
}
resource "pagerduty_business_service" "legacy_infra_nonprod" {
  name        = "Legacy Non-Prod"
  description = "JBOSS-Legacy Non-Production Infrastructure"
  team        = pagerduty_team.maist.id
}



##
##############################################
#
#    88""Yb 88""Yb  dP"Yb  8888b.                                 
#    88__dP 88__dP dP   Yb  8I  Yb                                
#    88"""  88"Yb  Yb   dP  8I  dY                                
#    88     88  Yb  YbodP  8888Y"     
#
##############################################
### PROD components

resource "pagerduty_business_service" "legacy_appserver_prod" {
  name        = "ApplicationServers-PROD"
  description = "Application Servers Service"
  team        = pagerduty_team.maist.id
}

resource "pagerduty_business_service" "legacy_jsfserver_prod" {
  name        = "JSFServers-PROD"
  description = "JSF Application Servers Service"
  team        = pagerduty_team.maist.id
}

resource "pagerduty_business_service" "legacy_http_prod" {
  name        = "HTTPServers-PROD"
  description = "HTTP Servers (Apache) Service"
  team        = pagerduty_team.maist.id
}




#######################################################################
#
#    88b 88  dP"Yb  88b 88          88""Yb 88""Yb  dP"Yb  8888b.  
#    88Yb88 dP   Yb 88Yb88 ________ 88__dP 88__dP dP   Yb  8I  Yb 
#    88 Y88 Yb   dP 88 Y88 """""""" 88"""  88"Yb  Yb   dP  8I  dY 
#    88  Y8  YbodP  88  Y8          88     88  Yb  YbodP  8888Y"  
#
#######################################################################
### NON-PROD Components
resource "pagerduty_business_service" "legacy_appserver_nonprod" {
  name        = "ApplicationServers-NON-PROD"
  description = "Application Servers Service"
  team        = pagerduty_team.maist.id
}

resource "pagerduty_business_service" "legacy_jsfserver_nonprod" {
  name        = "JSF Servers-NON-PROD"
  description = "JSF Application Servers Service"
  team        = pagerduty_team.maist.id
}

resource "pagerduty_business_service" "legacy_http_nonprod" {
  name        = "HTTPServers-NON-PROD"
  description = "HTTP Servers (Apache) Service"
  team        = pagerduty_team.maist.id
}


