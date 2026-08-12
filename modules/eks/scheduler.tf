####################### NODE GROUP SCHEDULER #######################

resource "aws_autoscaling_schedule" "up" {
  scheduled_action_name  = "${var.project.env}-${var.project.name}-eks-node-group-scale-up"
  min_size               = 2
  max_size               = 4
  desired_capacity       = 3
  recurrence             = "0 9 * * MON-FRI"
  time_zone              = "Asia/Singapore"
  autoscaling_group_name = aws_eks_node_group.node_group.resources[0].autoscaling_groups[0].name

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.node_group,
  ]
}

resource "aws_autoscaling_schedule" "down" {
  scheduled_action_name  = "${var.project.env}-${var.project.name}-eks-node-group-scale-down"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "0 18 * * MON-FRI"
  time_zone              = "Asia/Singapore"
  autoscaling_group_name = aws_eks_node_group.node_group.resources[0].autoscaling_groups[0].name

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.node_group,
  ]
}
