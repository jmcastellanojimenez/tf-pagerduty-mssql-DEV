##
# The local module "service" provider specifications
##

terraform {
  required_providers {
    pagerduty = {
      source  = "PagerDuty/pagerduty"
      version = "3.14.3"
    }

    github = {
      source  = "integrations/github"
      version = "6.2.2"
    }
  }
}
