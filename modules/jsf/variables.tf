##
# The local module "service" Variables
##

variable "service_name" {
  type        = string
  description = "The Service Name to be Created."
}

variable "service_description" {
  type        = string
  description = "The Service Description."
}

variable "service_environment" {
  type        = string
  default     = null
  description = "The Service Environment (can be 'null' for catchall services without environments)."
#  nullable    = true
}

variable "service_escalation_policy" {
  type        = string
  description = "The Service Escalation Policy to be attached to the Service."
}

variable "service_urgency" {
  type        = string
  default     = "severity_based"
  description = "The Service Urgency. Either 'low', 'high' or 'severity_based'. Defaults to 'severity_based'."

  validation {
    condition     = var.service_urgency == "low" || var.service_urgency == "high" || var.service_urgency == "severity_based"
    error_message = "The service_urgency value can only be either 'low', 'high' or 'severity_based'."
  }
}

variable "legacy_prod_bs_id" {
  type        = string
  description = "The id of the Prod Business Service to which the legacy_app is linked."
}
variable "legacy_nonprod_bs_id" {
  type        = string
  description = "The id of the NonProd Business Service to which the legacy_app is linked."
}

variable "service_default_prio" {
  type        = string
  default     = "p5"
  description = "Default priority to assign to events with no priority informed."

  validation {
     condition = var.service_default_prio == "p1" || var.service_default_prio == "p2" || var.service_default_prio == "p3" || var.service_default_prio == "p4" || var.service_default_prio == "p5" 
     error_message = "Default priority must be from p1 to p5"
  }
}

variable "oi_link" {
  type = string
  default = ""
  description = "Link to the operators instructions."
}

variable "svc_calendar" {
  type = string
  default = "Always"
  description = "Name of the calendar the service is disabled."
}

variable "time_windows" {
   type = map
   default = {
    period_id = ""
    calendar_name = ""
    condition_str = ""
    last_field = ""
   }

   description = "The different periods that form a disabled window (calendar)."
}



##### To be considered.
# Slack Related Variables
variable "slack_epo_workspaceid" {
  type        = string
  default     = "TLGQWQ19C"
  description = "The Service Slack WorkSpace ID. (This needs to already exist)"
}

variable "slack_channel_alertsnonprod" {
  type        = string
  default     = "XXXXXXX"
  description = "The Non-Prod Legacy Slack Channel."
}

variable "slack_channel_alertsprod" {
  type        = string
  default     = "YYYYYYY"
  description = "The Prod Legacy Slack Channel."
}

variable "slack_channel_alertscatchall" {
  type        = string
  default     = "ZZZZZZZ"
  description = "The Catchall Legacy Slack Channel."
}

