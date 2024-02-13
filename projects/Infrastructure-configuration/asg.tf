data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix            = "${var.environment}-ecs-template"
  image_id               = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type          = "t3.micro"
  vpc_security_group_ids = module.vpc.security_group_ids
  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config;
    EOF
  )

  credit_specification {
    cpu_credits = "standard"
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_node.arn
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.environment}-ecs-instance"
    }
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name_prefix         = "${var.environment}-asg"
  vpc_zone_identifier = module.vpc.subnet_ids

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  min_size                  = 6
  max_size                  = 6
  desired_capacity          = 6
  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}
