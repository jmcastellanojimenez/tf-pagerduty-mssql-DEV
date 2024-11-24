##
# Here we define Services that should be created.´
# The local modules:
#  - "./modules/service" 
#  - "./modules/http" 
#  - "./modules/jsf" 
# are used to configure the three types of services.
# This way we create all Services always the same way.
# The list of services (legacy_apps,http_instances and jsfs) is defiend in its own configuration file.
##


# Services
## JBOSS Catchall PROD
module "legacy_app_prod_catchall" {
  source = "./modules/service"

  service_name              = "MAIST Legacy Applications - PROD Catchall"
  service_environment       = "Production"
  service_description       = "For Legacy Platform alerts not routed to any other service"
  service_escalation_policy = pagerduty_escalation_policy.maist_email.id
  service_default_prio      = "p5"


  legacy_prod_bs_id    = pagerduty_business_service.legacy_appserver_prod.id
  legacy_nonprod_bs_id = pagerduty_business_service.legacy_appserver_nonprod.id


  oi_link     = "https://epoprod.service-now.com/sp?id=kb_article_view&sysparm_article=KB0052479"
  ads_context = ""


}

## JBOSS Catchall NON-PROD
module "legacy_app_nonprod_catchall" {
  source = "./modules/service"

  service_name              = "MAIST Legacy Applications - NON-PROD Catchall"
  service_environment       = "Non-Production"
  service_description       = "For Legacy Platform alerts not routed to any other service NON-PROD"
  service_escalation_policy = pagerduty_escalation_policy.maist_email.id
  service_default_prio      = "p5"


  legacy_prod_bs_id    = pagerduty_business_service.legacy_appserver_prod.id
  legacy_nonprod_bs_id = pagerduty_business_service.legacy_appserver_nonprod.id


  oi_link     = "https://epoprod.service-now.com/sp?id=kb_article_view&sysparm_article=KB0052479"
  ads_context = ""

}



#Contains all the legacy application instances and http instances integrated into PD events management.
locals {

  legacy_apps = csvdecode(file("${path.module}/csv/zz_legacy_apps-alt-prio.csv"))
  apps = { for app in local.legacy_apps : app.app_id => app }
  apps_prod    = { for app in local.legacy_apps : app.app_id => app if app.service_environment == "Production"}
  apps_nonprod = { for app in local.legacy_apps : app.app_id => app if app.service_environment != "Production"}


  http_instances_csv = csvdecode(file("${path.module}/csv/zz_http_instances.csv"))
  http_instances     = { for instance in local.http_instances_csv : instance.http_id => instance }
  http_instances_prod = { for instance in local.http_instances_csv : instance.http_id => instance if instance.service_environment == "Production" }
  http_instances_nonprod = { for instance in local.http_instances_csv : instance.http_id => instance if instance.service_environment != "Production" }


  legacy_jsfs = csvdecode(file("${path.module}/csv/zz_legacy_jsfs.csv"))
  jsfs        = { for jsf in local.legacy_jsfs : jsf.jsf_id => jsf }
  jsfs_prod           = { for jsf in local.legacy_jsfs : jsf.jsf_id => jsf if jsf.service_environment == "Production" }
  jsfs_nonprod        = { for jsf in local.legacy_jsfs : jsf.jsf_id => jsf if jsf.service_environment != "Production" }


  time_periods_csv = csvdecode(file("${path.module}/csv/zz_svc_schedules.csv"))
  time_periods = { for period in local.time_periods_csv : period.period_id => period }

}


#Read the escalation policies used in the CSV into a variable to assign them to the apps defined in the CSV
data "pagerduty_escalation_policy" "app_esc_policies" {
  for_each = local.apps
  name     = each.value.esc_policy
}
data "pagerduty_escalation_policy" "http_esc_policies" {
  for_each = local.http_instances
  name     = each.value.esc_policy
}
data "pagerduty_escalation_policy" "jsf_esc_policies" {
  for_each = local.jsfs
  name     = each.value.esc_policy
}


module "legacy_app" {
  source = "./modules/service"

  for_each = local.apps

  service_name = join("", ["amf-", each.value.package_id, "_", each.value.install_instance])
  service_description = templatefile("${path.root}/templates/svc_descr.tftpl",
    { desc        = join("", ["Legacy AMF-TF-", each.value.package_id])
      oi_link     = each.value.oi_link
      ads_context = each.value.ads_context
  })



  service_environment = each.value.service_environment
  #Same fixed escalation for all services
  #  service_escalation_policy = pagerduty_escalation_policy.maist_default.id
  #Escalation policy to apply to each service based in the application definition.
  service_escalation_policy = data.pagerduty_escalation_policy.app_esc_policies[each.key].id
  service_default_prio      = each.value.jserviceprobe_prio != "" ? each.value.jserviceprobe_prio : "p5"
  service_business_prio      = each.value.business_prio != "" ? each.value.business_prio : each.value.jserviceprobe_prio

  legacy_prod_bs_id    = pagerduty_business_service.legacy_appserver_prod.id
  legacy_nonprod_bs_id = pagerduty_business_service.legacy_appserver_nonprod.id

  oi_link     = each.value.oi_link
  ads_context = each.value.ads_context
  svc_calendar = each.value.svc_calendar
  time_windows = { for period in local.time_periods_csv : period.period_id => period if period.calendar_name == each.value.svc_calendar }
}



## HTTP Catchall PROD
module "legacy_http_prod_catchall" {
  source = "./modules/http"

  service_name              = "MAIST HTTP PROD Instances - Catchall"
  service_environment       = "Production"
  service_description       = "For HTTP Legacy Platform alerts not routed to any other service"
  service_escalation_policy = pagerduty_escalation_policy.maist_email.id
  service_default_prio      = "p5"


  legacy_prod_bs_id    = pagerduty_business_service.legacy_http_prod.id
  legacy_nonprod_bs_id = pagerduty_business_service.legacy_http_nonprod.id


  oi_link     = "https://epoprod.service-now.com/sp?id=kb_article_view&sysparm_article=KB0052129"


}

## HTTP Catchall NON-PROD
module "legacy_http_nonprod_catchall" {
  source = "./modules/http"

  service_name              = "MAIST HTTP NON-PROD Instances - Catchall"
  service_environment       = "Non-Production"
  service_description       = "For HTTP Legacy Platform alerts not routed to any other service NON-PROD"
  service_escalation_policy = pagerduty_escalation_policy.maist_email.id
  service_default_prio      = "p5"


  legacy_prod_bs_id    = pagerduty_business_service.legacy_http_prod.id
  legacy_nonprod_bs_id = pagerduty_business_service.legacy_http_nonprod.id


  oi_link     = "https://epoprod.service-now.com/sp?id=kb_article_view&sysparm_article=KB0052129"

}



module "http_instance" {
  source = "./modules/http"

  for_each = local.http_instances

  service_name = join("", ["http-", each.key])
  service_description = templatefile("${path.root}/templates/http_descr.tftpl",
    { desc        = join("", ["Legacy HTTP-TF instance: ", each.key])
      oi_link     = "https://epoprod.service-now.com/sp?id=kb_article_view&sysparm_article=KB0052129"
  })


  service_environment = each.value.service_environment
  #Same fixed escalation for all services
  #  service_escalation_policy = pagerduty_escalation_policy.maist_default.id
  #Escalation policy to apply to each service based in the application definition.
  service_escalation_policy = data.pagerduty_escalation_policy.http_esc_policies[each.key].id
  service_default_prio      = "p3"


  legacy_prod_bs_id    = pagerduty_business_service.legacy_http_prod.id
  legacy_nonprod_bs_id = pagerduty_business_service.legacy_http_nonprod.id

  

}

## JSF Catchall PROD
module "legacy_jsf_prod_catchall" {
  source = "./modules/jsf"

  service_name              = "MAIST JSF PROD Services - Catchall"
  service_environment       = "Production"
  service_description       = "For JSF Legacy Platform alerts not routed to any other service"
  service_escalation_policy = pagerduty_escalation_policy.maist_email.id
  service_default_prio      = "p5"


  legacy_prod_bs_id    = pagerduty_business_service.legacy_jsfserver_prod.id
  legacy_nonprod_bs_id = pagerduty_business_service.legacy_jsfserver_nonprod.id


  oi_link     = "https://epoprod.service-now.com/sp?id=kb_article_view&sysparm_article=KB0052132"


}

## JSF Catchall NON-PROD
module "legacy_jsf_nonprod_catchall" {
  source = "./modules/jsf"

  service_name              = "MAIST JSF NON-PROD Services - Catchall"
  service_environment       = "Non-Production"
  service_description       = "For JSF Legacy Platform alerts not routed to any other service NON-PROD"
  service_escalation_policy = pagerduty_escalation_policy.maist_email.id
  service_default_prio      = "p5"


  legacy_prod_bs_id    = pagerduty_business_service.legacy_jsfserver_prod.id
  legacy_nonprod_bs_id = pagerduty_business_service.legacy_jsfserver_nonprod.id


  oi_link     = "https://epoprod.service-now.com/sp?id=kb_article_view&sysparm_article=KB0052132"

}



module "legacy_jsf" {
  source = "./modules/jsf"

  for_each = local.jsfs

  service_name        = join("", [each.value.env_key, "_JSF_", each.value.jsf_name])
  service_description = templatefile("${path.root}/templates/jsf_descr.tftpl",
    { desc        = join("", ["Legacy JSF-TF- ", each.value.jsf_descr])
      oi_link     = "https://epoprod.service-now.com/sp?id=kb_article_view&sysparm_article=KB0052132"
  })




  service_environment = each.value.service_environment
  #Same fixed escalation for all services
  #  service_escalation_policy = pagerduty_escalation_policy.maist_default.id
  #Escalation policy to apply to each service based in the application definition.
  service_escalation_policy = data.pagerduty_escalation_policy.jsf_esc_policies[each.key].id
  service_default_prio      = each.value.jsf_monitor_prio != "" ? each.value.jsf_monitor_prio : "p3"

  legacy_prod_bs_id    = pagerduty_business_service.legacy_jsfserver_prod.id
  legacy_nonprod_bs_id = pagerduty_business_service.legacy_jsfserver_nonprod.id

  svc_calendar = each.value.svc_calendar
  time_windows = { for period in local.time_periods_csv : period.period_id => period if period.calendar_name == each.value.svc_calendar }
}


