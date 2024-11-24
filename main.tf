##
# EPO - MFR Platform Terraform Code for Pagerduty Configurations
# 
# TF Providers used:
#   - Pagerduty: https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs
#   - GitHub: https://registry.terraform.io/providers/integrations/github/latest/docs
##
## TEST

# Important:
## When running locally dont forget to export the following environment variables:
##   - PAGERDUTY_TOKEN
##   - PAGERDUTY_USER_TOKEN
##   - GITHUB_TOKEN
##
## If executed inside the GitHub Pipeline these variables will already be configured as Repository secrets.


# Providers
provider "pagerduty" {}

#provider "github" {
#  base_url = "https://git.epo.org/"
#  owner    = "unixapp-maist"
#}
