#-------------------------------------EC2 Instance-------------------------------------#
resource "aws_instance" "ec2" {
  count                  = var.enable_asg ? 0 : 1  # Only create if ASG is disabled
  ami                    = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu-ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  subnet_id              = var.subnet_id
  key_name               = var.key_name #aws_key_pair.key_pair.key_name
  root_block_device {
    delete_on_termination = true
    iops                  = var.iops
    volume_size           = var.volume_size
    volume_type           = "gp3"
  }
  depends_on = [
    aws_security_group.ec2-sg
  ]

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.instance_name}"
  })

  user_data = var.path_user_data != "" ? file("${var.path_user_data}") : null
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  lifecycle {
    ignore_changes = [
      user_data
    ]
  }
}

# #-------------------------------------Key pair-------------------------------------#
# resource "aws_key_pair" "key_pair" {
#   key_name   = "${var.project.env}-${var.project.name}"
#   public_key = file("${var.path_public_key}")
# }

#-------------------------------------Launch Template for ASG-------------------------------------#
resource "aws_launch_template" "launch_template" {
  count         = var.enable_asg ? 1 : 0
  name_prefix   = "${var.project.env}-${var.project.name}-${var.instance_name}-"
  image_id      = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu-ami.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = true
      volume_size           = var.volume_size
      volume_type           = "gp3"
      iops                  = var.iops
    }
  }

  user_data = var.path_user_data != "" ? base64encode(file("${var.path_user_data}")) : null

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = "${var.project.env}-${var.project.name}-${var.instance_name}"
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(var.tags, {
      Name = "${var.project.env}-${var.project.name}-${var.instance_name}-volume"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

