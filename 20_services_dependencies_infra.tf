##
# Here we define Services Dependencies 
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/service_dependency
##

# Grab Data from other Relevant Services not currently managed by Terraform



# Service Dependencies
## CatchAll Related Service Dependencies
### The Legacy Platform Business Service USES the Legacy CatchAll Technical Service
#resource "pagerduty_service_dependency" "legacy_catchall_infra" {
#  dependency {
#    supporting_service {
#      id   = module.legacy_app_prod_catchall.id
#      type = module.legacy_app_prod_catchall.type
#    }
#    dependent_service {
#      id   = pagerduty_business_service.legacy_platform.id
#      type = "business_service"
#    }
#  }
#}

##############################################
#
#    88""Yb 88""Yb  dP"Yb  8888b.                                 
#    88__dP 88__dP dP   Yb  8I  Yb                                
#    88"""  88"Yb  Yb   dP  8I  dY                                
#    88     88  Yb  YbodP  8888Y"     
#
##############################################
## PROD Related Service Dependencies
### The Legacy Platform Business Service USES the Legacy Prod Environment Business Service
resource "pagerduty_service_dependency" "legacy_infra_prod" {
  dependency {
    supporting_service {
      id   = pagerduty_business_service.legacy_infra_prod.id
      type = "business_service"
    }
    dependent_service {
      id   = pagerduty_business_service.legacy_platform.id
      type = "business_service"
    }
  }
}

### The Legacy Prod Environment Business Service USES the Appserver Prod Business Service
resource "pagerduty_service_dependency" "legacy_infra_prod_appserver" {
  dependency {
    supporting_service {
      id   = pagerduty_business_service.legacy_appserver_prod.id
      type = "business_service"
    }
    dependent_service {
      id   = pagerduty_business_service.legacy_infra_prod.id
      type = "business_service"
    }
  }
}

### The Appserver Prod Business Service USES all the legacy_app services
#this supporting relation is defined inside the legacy_app services module


### The Legacy Prod Environment Business Service USES the HTTP Prod Business Service
resource "pagerduty_service_dependency" "legacy_infra_prod_http" {
  dependency {
    supporting_service {
      id   = pagerduty_business_service.legacy_http_prod.id
      type = "business_service"
    }
    dependent_service {
      id   = pagerduty_business_service.legacy_infra_prod.id
      type = "business_service"
    }
  }
}

### The HTTP Prod Business Service USES all the http instances services
#this supporting relation is defined inside the http_instance service module


### The Legacy Prod Environment Business Service USES the JSF Appserver Prod Business Service
resource "pagerduty_service_dependency" "legacy_infra_prod_jsfserver" {
  dependency {
    supporting_service {
      id   = pagerduty_business_service.legacy_jsfserver_prod.id
      type = "business_service"
    }
    dependent_service {
      id   = pagerduty_business_service.legacy_infra_prod.id
      type = "business_service"
    }
  }
}

### The Appserver Prod Business Service USES all the legacy_jsf services
#this supporting relation is defined inside the legacy_jsf service module


#######################################################################
#
#    88b 88  dP"Yb  88b 88          88""Yb 88""Yb  dP"Yb  8888b.  
#    88Yb88 dP   Yb 88Yb88 ________ 88__dP 88__dP dP   Yb  8I  Yb 
#    88 Y88 Yb   dP 88 Y88 """""""" 88"""  88"Yb  Yb   dP  8I  dY 
#    88  Y8  YbodP  88  Y8          88     88  Yb  YbodP  8888Y"  
#
#######################################################################
## NON-PROD Related Service Dependencies
#
#
### The Legacy Platform Business Service USES the Legacy NonProd Environment Business Service
resource "pagerduty_service_dependency" "legacy_infra_nonprod" {
  dependency {
    supporting_service {
      id   = pagerduty_business_service.legacy_infra_nonprod.id
      type = "business_service"
    }
    dependent_service {
      id   = pagerduty_business_service.legacy_platform.id
      type = "business_service"
    }
  }
}

### The Legacy NonProd Environment Business Service USES the Appserver NonProd Business Service
resource "pagerduty_service_dependency" "legacy_infra_nonprod_appserver" {
  dependency {
    supporting_service {
      id   = pagerduty_business_service.legacy_appserver_nonprod.id
      type = "business_service"
    }
    dependent_service {
      id   = pagerduty_business_service.legacy_infra_nonprod.id
      type = "business_service"
    }
  }
}

### The Appserver NonProd Business Service USES all the legacy_app services
#this supporting relation is defined inside the legacy_app services module


### The Legacy NonProd Environment Business Service USES the HTTP NonProd Business Service
resource "pagerduty_service_dependency" "legacy_infra_nonprod_http" {
  dependency {
    supporting_service {
      id   = pagerduty_business_service.legacy_http_nonprod.id
      type = "business_service"
    }
    dependent_service {
      id   = pagerduty_business_service.legacy_infra_nonprod.id
      type = "business_service"
    }
  }
}

### The HTTP NonProd Business Service USES all the HTTP services
#this supporting relation is defined inside the http_instance services module


### The Legacy NonProd Environment Business Service USES the JSF server NonProd Business Service
resource "pagerduty_service_dependency" "legacy_infra_nonprod_jsfserver" {
  dependency {
    supporting_service {
      id   = pagerduty_business_service.legacy_jsfserver_nonprod.id
      type = "business_service"
    }
    dependent_service {
      id   = pagerduty_business_service.legacy_infra_nonprod.id
      type = "business_service"
    }
  }
}

### The Appserver NonProd Business Service USES all the legacy_jsf services
#this supporting relation is defined inside the legacy_jsf services module

