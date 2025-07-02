# sns.tf

resource "aws_sns_topic" "app-alerts-topic" {
  name = "app-alert-topic-${var.stage}"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.app-alerts-topic.arn
  protocol  = "email"
  endpoint  = var.alert_email                           # set this in dev.tfvars and prod.tfvars
}