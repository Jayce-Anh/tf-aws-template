output "ec2_sg_id" {
  value = aws_security_group.ec2-sg.id
}

output "ec2_id" {
  value = length(aws_instance.ec2) > 0 ? aws_instance.ec2[0].id : null
}

output "public_ip" {
  value = length(aws_instance.ec2) > 0 ? aws_instance.ec2[0].public_ip : null
}

output "private_ip" {
  value = length(aws_instance.ec2) > 0 ? aws_instance.ec2[0].private_ip : null
}

#---------------------Auto Scaling Group Outputs---------------------#
output "asg_id" {
  value       = length(aws_autoscaling_group.asg) > 0 ? aws_autoscaling_group.asg[0].id : null
  description = "Auto Scaling Group ID"
}

output "asg_name" {
  value       = length(aws_autoscaling_group.asg) > 0 ? aws_autoscaling_group.asg[0].name : null
  description = "Auto Scaling Group name"
}

output "asg_arn" {
  value       = length(aws_autoscaling_group.asg) > 0 ? aws_autoscaling_group.asg[0].arn : null
  description = "Auto Scaling Group ARN"
}

output "asg_desired_capacity" {
  value       = length(aws_autoscaling_group.asg) > 0 ? aws_autoscaling_group.asg[0].desired_capacity : null
  description = "Desired capacity of the Auto Scaling Group"
}

output "asg_min_size" {
  value       = length(aws_autoscaling_group.asg) > 0 ? aws_autoscaling_group.asg[0].min_size : null
  description = "Minimum size of the Auto Scaling Group"
}

output "asg_max_size" {
  value       = length(aws_autoscaling_group.asg) > 0 ? aws_autoscaling_group.asg[0].max_size : null
  description = "Maximum size of the Auto Scaling Group"
}

output "launch_template_id" {
  value       = length(aws_launch_template.launch_template) > 0 ? aws_launch_template.launch_template[0].id : null
  description = "Launch Template ID"
}

output "launch_template_latest_version" {
  value       = length(aws_launch_template.launch_template) > 0 ? aws_launch_template.launch_template[0].latest_version : null
  description = "Latest version of the Launch Template"
}

output "cpu_scaling_policy_arn" {
  value       = length(aws_autoscaling_policy.cpu_target_tracking) > 0 ? aws_autoscaling_policy.cpu_target_tracking[0].arn : null
  description = "ARN of the CPU target tracking scaling policy"
}

output "scale_up_policy_arn" {
  value       = length(aws_autoscaling_policy.scale_up) > 0 ? aws_autoscaling_policy.scale_up[0].arn : null
  description = "ARN of the scale up policy"
}

output "scale_down_policy_arn" {
  value       = length(aws_autoscaling_policy.scale_down) > 0 ? aws_autoscaling_policy.scale_down[0].arn : null
  description = "ARN of the scale down policy"
}