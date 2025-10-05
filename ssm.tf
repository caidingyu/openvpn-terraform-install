locals {
  enabled_schedules = {
    for k, v in var.schedules : k => v if lookup(v, "enabled", true)
  }
}

# Start associations
resource "aws_ssm_association" "start" {
  for_each                           = local.enabled_schedules
  name                               = "AWS-StartEC2Instance"
  schedule_expression                = each.value.start_cron
  automation_target_parameter_name   = "InstanceId"
  parameters                         = { AutomationAssumeRole = aws_iam_role.ssm_automation.arn }

  targets {
    key    = "tag:${var.schedule_tag_key}"
    values = [each.value.tag_value]
  }
}

# Stop associations
resource "aws_ssm_association" "stop" {
  for_each                           = local.enabled_schedules
  name                               = "AWS-StopEC2Instance"
  schedule_expression                = each.value.stop_cron
  automation_target_parameter_name   = "InstanceId"
  parameters                         = { AutomationAssumeRole = aws_iam_role.ssm_automation.arn }

  targets {
    key    = "tag:${var.schedule_tag_key}"
    values = [each.value.tag_value]
  }
}