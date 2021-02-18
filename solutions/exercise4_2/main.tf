
  ##############################################################
  # Data sources to get VPC, subnets and security group details
  ##############################################################
  data "aws_vpc" "default" {
    default = true
  }

  data "aws_subnet_ids" "all" {
    vpc_id = data.aws_vpc.default.id
  }

  data "aws_security_group" "default" {
    vpc_id = data.aws_vpc.default.id
    name   = "default"
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "service"

  # Launch configuration
  lc_name = "example-lc"

  image_id        = "ami-0233214e13e500f77"
  instance_type   = "t2.micro"
  #security_groups = ["sg-12345678"]

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "example-asg"
  vpc_zone_identifier       = data.aws_subnet_ids.all.ids
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
}
