locals {
  instance_ids = concat(
    aws_instance.web.*.id,
    aws_instance.dashd_wallet.*.id,
    aws_instance.dashd_full_node.*.id,
    aws_instance.miner.*.id,
    aws_instance.masternode.*.id,
    aws_instance.vpn.*.id,
  )
  instance_hostnames = concat(
    aws_instance.web.*.tags.Hostname,
    aws_instance.dashd_wallet.*.tags.Hostname,
    aws_instance.dashd_full_node.*.tags.Hostname,
    aws_instance.miner.*.tags.Hostname,
    aws_instance.masternode.*.tags.Hostname,
    aws_instance.vpn.*.tags.Hostname,
  )
}

resource "aws_cloudwatch_metric_alarm" "cpu_monitoring" {

  count = length(local.instance_ids)

  alarm_name          = "${terraform.workspace}-${local.instance_hostnames[count.index]}-cpu-monitoring"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "360"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    InstanceId = local.instance_ids[count.index]
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  #  alarm_actions     = ["${aws_autoscaling_policy.bat.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "memory_monitoring" {

  count = length(local.instance_ids)

  alarm_name          = "${terraform.workspace}-${local.instance_hostnames[count.index]}-memory-monitoring"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "360"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    InstanceId = local.instance_ids[count.index]
  }

  alarm_description = "This metric monitors ec2 memory utilization"
  #  alarm_actions     = ["${aws_autoscaling_policy.bat.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "swap_monitoring" {

  count = length(local.instance_ids)

  alarm_name          = "${terraform.workspace}-${local.instance_hostnames[count.index]}-swap-monitoring"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "SwapUtilization"
  namespace           = "System/Linux"
  period              = "360"
  statistic           = "Average"
  threshold           = "15"

  dimensions = {
    InstanceId = local.instance_ids[count.index]
  }

  alarm_description = "This metric monitors ec2 swap utilization"
  #  alarm_actions     = ["${aws_autoscaling_policy.bat.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "diskspace_monitoring" {

  count = length(local.instance_ids)

  alarm_name          = "${terraform.workspace}-${local.instance_hostnames[count.index]}-diskspace-monitoring"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "DiskSpaceUtilization"
  namespace           = "System/Linux"
  period              = "360"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    InstanceId = local.instance_ids[count.index]
    MountPath  = "/"
    Filesystem = "/dev/nvme0n1p1"
  }

  alarm_description = "This metric monitors ec2 disk utilization"
  #  alarm_actions     = ["${aws_autoscaling_policy.bat.arn}"]
}
