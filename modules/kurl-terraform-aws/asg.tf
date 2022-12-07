# AMI of the latest Amazon Linux 2
data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

resource "aws_launch_template" "master" {
  name_prefix   = "${var.name}-kurl-master-instance"
  image_id      = var.image_id != "" ? var.image_id : data.aws_ami.this.id
  instance_type = "t3.xlarge"

  iam_instance_profile {
    name = aws_iam_instance_profile.master.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.master.id]
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.common_master_tags
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      encrypted             = false
      volume_size           = 40
      volume_type           = "gp2"
    }
  }

  user_data   = base64encode(data.template_file.master_user_data.rendered)
  description = "Launch template for kurl master instance ${var.name}"
  tags        = local.common_master_tags
}

resource "aws_autoscaling_group" "master" {
  name                = "${var.name}-kurl-master-asg"
  vpc_zone_identifier = var.master_subnets
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = aws_launch_template.master.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "node" {
  name_prefix   = "${var.name}-kurl-node-instance"
  image_id      = var.image_id != "" ? var.image_id : data.aws_ami.this.id
  instance_type = "t3.xlarge"

  iam_instance_profile {
    name = aws_iam_instance_profile.node.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.node.id]
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.common_node_tags
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      encrypted             = false
      volume_size           = 40
      volume_type           = "gp2"
    }
  }

  user_data   = base64encode(data.template_file.node_user_data.rendered)
  description = "Launch template for kurl node instance ${var.name}"
  tags        = local.common_node_tags
}

resource "aws_autoscaling_group" "node" {
  name                = "${var.name}-kurl-node-asg"
  vpc_zone_identifier = var.node_subnets
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = aws_launch_template.node.id
    version = "$Latest"
  }

  depends_on = [
    data.aws_ssm_parameter.join_node
  ]
}
