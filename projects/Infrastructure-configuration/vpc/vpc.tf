resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_config.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.environment} vpc"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.environment} gateway"
  }

  timeouts {
    create = "5m"
    delete = "5m"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = var.vpc_config.azs_count
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = local.azs[count.index]
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1 + count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.azs[count.index]}-${var.environment}-subnet"
  }
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.vpc_config.cidr_allow_all
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.environment} route table"
  }
}

resource "aws_route_table_association" "subnet_route" {
  count          = var.vpc_config.azs_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_security_group" "ecs_sg" {
  name_prefix = "${var.environment}-ecs-"
  description = "Allow all traffic within the VPC"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = [var.vpc_config.cidr_allow_all]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = [var.vpc_config.cidr_allow_all]
  }

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    delete = "2m"
  }
}
