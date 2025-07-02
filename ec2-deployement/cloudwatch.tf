# cloudwatch.tf

resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ec2/${var.stage}-my-app.log"
  retention_in_days = 7
  

  tags = {
    Name = "AppLogGroup-${var.stage}"
  }
}

# metric_filter.tf

resource "aws_cloudwatch_log_metric_filter" "App_error_filter" {
  name           = "app-error-filter-${var.stage}"
  log_group_name = aws_cloudwatch_log_group.app_log_group.name
  pattern        = "?Error ?Exception"

  metric_transformation {
    name      = "AppErrors-${var.stage}"
    namespace = "AppLogMetrics"
    value     = "1"
  }
   depends_on          = [aws_cloudwatch_log_group.app_log_group]
}

resource "aws_cloudwatch_metric_alarm" "App_error_alarm" {
  alarm_name          = "App-error-alarm-${var.stage}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.App_error_filter.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.App_error_filter.metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Triggers if there is an error/exception in app-logs."
  alarm_actions       = [aws_sns_topic.app-alerts-topic.arn]
  depends_on          = [aws_cloudwatch_log_metric_filter.App_error_filter]
}
