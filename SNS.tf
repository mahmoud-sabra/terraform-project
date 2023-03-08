# creating sns topic for all the auto scaling groups
resource "aws_sns_topic" "iac-sns" {
  name = "Default_CloudWatch_Alarms_Topic"
}

resource "aws_autoscaling_notification" "iac_notifications" {
  group_names = [
    aws_autoscaling_group.bastion_asg.name,
    aws_autoscaling_group.nginx_asg.name,
    aws_autoscaling_group.webserver_asg.name,
  ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.iac-sns.arn
}