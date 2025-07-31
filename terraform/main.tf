terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
}

resource "aws_instance" "webserver-techeazy" {
  ami                    = var.ami_value
  instance_type          = var.instance_type_value
  subnet_id              = var.subnet_id_defaultVPC
  iam_instance_profile   = data.terraform_remote_state.shared_role.outputs.ec2-instance-profile
  associate_public_ip_address = true
  vpc_security_group_ids = [data.terraform_remote_state.shared_role.outputs.techeazy-security-group]
  user_data = base64encode(templatefile("../scripts/${var.stage}_script.sh",{
    STOP_INSTANCE       = var.stop_after_minutes # Match STOP_INSTANCE in script
    S3_BUCKET_NAME      = data.terraform_remote_state.shared_role.outputs.s3_log_bucket
    GITHUB_TOKEN        = nonsensitive(var.github_token)
    cloudwatch_agent_config = data.template_file.cw_agent_config.rendered
  }))
  tags = {
    Name = "${var.instance_name}-${var.stage}"
  }
  depends_on = [ data.terraform_remote_state.shared_role ]
}

data "terraform_remote_state" "shared_role" {
  backend = "s3"
  config = {
    bucket = "rajguptackt22-terraform-state"
    key    = "shared/terraform.tfstate"
    region = "ap-south-1"
  }
}

resource "aws_sns_topic" "alarm_topic" {
  name = "cloudwatch-log-error-topic-${var.stage}"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_log_group" "cloudwatch-log-group" {
  name = "${var.instance_name}-logs-${var.stage}"

  tags = {
    Environment = var.stage
    Application = var.instance_name
  }
}

resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "error-exception-filter"
  log_group_name =  aws_cloudwatch_log_group.cloudwatch-log-group.name
  pattern        = "?ERROR ?Exception"

  metric_transformation {
    name      = "ErrorCount"
    namespace = "LogMetrics"
    value     = "1"
  }
  depends_on = [aws_cloudwatch_log_group.cloudwatch-log-group]
}

resource "aws_cloudwatch_metric_alarm" "log_error_alarm" {
  alarm_name          = "LogErrorOrExceptionAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].namespace
  period              = 300 # 5 minutes
  statistic           = "Sum"
  threshold           = 2  # More than 1 datapoint means 2 or more
  alarm_description   = "Triggers when ERROR or Exception is found more than once in 5 minutes"
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]
}

data "template_file" "cw_agent_config" {
  template = file("${path.module}/../scripts/cloudwatch-agent-config.json")
  vars = {
    LOG_GROUP_NAME = aws_cloudwatch_log_group.cloudwatch-log-group.name
  }
}
