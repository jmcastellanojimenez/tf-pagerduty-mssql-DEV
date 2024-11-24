##
# Here we define the Schedules that are assigned to the different Teams
# - https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/schedule
##

# Schedules
## Operational OnCall
data "pagerduty_schedule" "maist_oncall" {
  name        = "MAIST Oncall Schedule"
}

#resource "pagerduty_schedule" "maist_oncall" {
#  name        = "MAIST Oncall Schedule"
#  description = "The MAIST Operations OnCall Schedule."
#  time_zone   = "Europe/Amsterdam"

#  layer {
#    name                         = "OnCall"
#    start                        = "2023-02-01T00:00:00-00:00"
#    rotation_virtual_start       = "2023-02-27T07:00:00+01:00"
#    rotation_turn_length_seconds = 604800
#    users = [
#      data.pagerduty_user.jribeiro.id,
#      data.pagerduty_user.mribeiro.id,
#      data.pagerduty_user.calmansa.id
#    ]
#  }

#  teams = [
#    pagerduty_team.maist.id
#  ]
#}

## Platform Business Hours (POW)
data "pagerduty_schedule" "maist_pow" {
  name        = "MAIST Business Schedule"
}

#resource "pagerduty_schedule" "maist_pow" {
#  name        = "MAIST Business Schedule"
#  description = "MAIST Operations Team POW Schedule."
#  time_zone   = "Europe/Amsterdam"
#
#  layer {
#    name                         = "pow"
#    start                        = "2023-02-01T00:00:00-00:00"
#    rotation_virtual_start       = "2023-02-27T07:00:00+01:00"
#    rotation_turn_length_seconds = 604800
#
#    restriction {
#      type              = "weekly_restriction"
#      start_time_of_day = "07:00:00"
#      start_day_of_week = 1     # Monday
#      duration_seconds  = 43200 # 12 hours (From 07:00 to 19:00)
#    }
#    restriction {
#      type              = "weekly_restriction"
#      start_time_of_day = "07:00:00"
#      start_day_of_week = 2     # Tuesday
#      duration_seconds  = 43200 # 12 hours (From 07:00 to 19:00)
#    }
#    restriction {
#      type              = "weekly_restriction"
#      start_time_of_day = "07:00:00"
#      start_day_of_week = 3     # Wednesday
#      duration_seconds  = 43200 # 12 hours (From 07:00 to 19:00)
#    }
#    restriction {
#      type              = "weekly_restriction"
#      start_time_of_day = "07:00:00"
#      start_day_of_week = 4     # Thursday
#      duration_seconds  = 43200 # 12 hours (From 07:00 to 19:00)
#    }
#    restriction {
#      type              = "weekly_restriction"
#      start_time_of_day = "07:00:00"
#      start_day_of_week = 5     # Friday
#      duration_seconds  = 43200 # 12 hours (From 07:00 to 19:00)
#    }
#
#    users = [
#      data.pagerduty_user.jribeiro.id,
#      data.pagerduty_user.mribeiro.id,
#      data.pagerduty_user.calmansa.id
#    ]
#  }
#
#  teams = [pagerduty_team.maist.id]
#}


## MAIST schedule for generic support
resource "pagerduty_schedule" "maist_support" {
  name        = "MAIST Support Schedule"
  description = "MAIST Schedule for generic support." 
  time_zone   = "Europe/Amsterdam"

  layer {
    name                         = "MAIST - Support"
    start                        = "2023-02-01T00:00:00-00:00"
    rotation_virtual_start       = "2023-02-27T07:00:00+01:00"
    rotation_turn_length_seconds = 604800
    users = [
      data.pagerduty_user.maist.id
    ]
  }

  teams = [
    pagerduty_team.maist.id
  ]
}


