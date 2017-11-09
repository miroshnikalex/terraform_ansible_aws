provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

### IAM

## S3 access

resource "aws_iam_instance_profile" "s3_access" {
  name  = "s3_access"
  roles = ["${aws_iam_role.s3_access.name}"]
}

resource "aws_iam_role_policy" "s3_access_policy" {
  name = "s3_access_policy"
  role = "${aws_iam_role.s3_access.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "s3_access" {
  name = "s3_access"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.awazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF
}

### VPC section

resource "aws_vpc" "${var.aws_custom_vpc}" {
  cidr_block = "10.1.0.0/16"
}

## IGW

resource "aws_internet_gateway" "${aws_custom_igw}" {
  vpc_id = "${aws_vpc.${var.aws_custom_vpc}.id}"
}

## Public RT

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.${var.aws_custom_vpc}.id}"

  route {
    cidr_block = "${public_cidr}"
    gateway_id = "${aws_internet_gateway.${var.aws_custom_igw}.id}"
  }

  tags {
    name = "public"
  }
}

## Private RT

resource "aws_default_route_table" "private" {
  default_route_table_id = "${aws_vpc.${var.aws_custom_vpc}.default_route_table_id}"

  tags {
    name = "private"
  }
}

## Subnets

# Public

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.${var.aws_custom_vpc}.id}"
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"

  tags {
    name = "public"
  }
}

# Private1

resource "aws_subnet" "private1" {
  vpc_id                  = "${aws_vpc.${var.aws_custom_vpc}.id}"
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-central-1b"

  tags {
    name = "private1"
  }
}

# Private2

resource "aws_subnet" "private2" {
  vpc_id                  = "${aws_vpc.${var.aws_custom_vpc}.id}"
  cidr_block              = "10.1.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-central-1c"

  tags {
    name = "private2"
  }
}

# RDS Subnet 1

resource "aws_subnet" "rds_subnet1" {
  vpc_id                  = "${aws_vpc.${var.aws_custom_vpc}.id}"
  cidr_block              = "10.1.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-central-1a"

  tags {
    name = "RDS 1"
  }
}

# RDS Subnet 2

resource "aws_subnet" "rds_subnet2" {
  vpc_id                  = "${aws_vpc.${var.aws_custom_vpc}.id}"
  cidr_block              = "10.1.5.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-central-1b"

  tags {
    name = "RDS 2"
  }
}

# RDS Subnet 3

resource "aws_subnet" "rds_subnet3" {
  vpc_id                  = "${aws_vpc.${var.aws_custom_vpc}.id}"
  cidr_block              = "10.1.6.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-central-1c"

  tags {
    name = "RDS 3"
  }
}

# Subnet associations - do not forget to replace it with NAT!!!

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private1_assoc" {
  subnet_id      = "${aws_subnet.private1.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private2_assoc" {
  subnet_id      = "${aws_subnet.private2.id}"
  route_table_id = "${aws_route_table.public.id}"
}

### Create RDS subnet group

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = ["${aws_subnet.rds_subnet1.id}", "${aws_subnet.rds_subnet2.id}", "${aws_subnet.rds_subnet3.id}"]

  tags {
    name = "rds_sng"
  }
}

### SGs

## Public

resource "aws_security_group" "public" {
  name        = "sg_public"
  description = "Used for public and private instances for LB access"
  vpc_id      = "${aws_vpc.${var.aws_custom_vpc}.id}"

  ## SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.localip}"]
  }
  ## HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ## HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ## Outbound Internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Private

resource "aws_security_group" "private" {
  name        = "sg_private"
  description = "Used for private instances"
  vpc_id      = "${aws_vpc.${aws_custom_vpc}.id}"
}

# Access from other security groups

ingress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["10.1.0.0/16"]
}

egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

## RDS

resource "aws_security_group" "RDS" {
  name        = "sg_rds"
  description = "Used for DB instances"
  vpc_id      = "${aws_vpc.${aws_custom_vpc}.id}"
}

# SQL access from public/private security group
ingress {
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  security_groups = ["${aws_security_group.public.id}", "${aws_security_group.private.id}"]
}

### Create S3 VPC Endpoint
resource "aws_vpc_endpoint" "private-s3" {
  vpc_id          = "${aws_vpc.${var.aws_custom_vpc}.id}"
  service_name    = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = ["${aws_vpc.${var.aws_custom_vpc}.default_route_table_id}", "${aws_route_table.public.id}"]

  policy = <<POLICY
  {
    "Statement": [
      {
        "Action": "*",
        "Effect": "Allow",
        "Resource": "*",
        "Principal": "*"
      }
    ]
  }
POLICY
}

### S3 code bucket

resource "aws_s3_bucket" "code" {
  name          = "${var.domain_name}_code123321"
  acl           = "private"
  force_destroy = true

  tags {
    name = "code bucket"
  }
}

### Compute resources

## key pair

resource "aws_key_pair" "${var.key_pair_name}" {
  key_name   = "${var.key_pair_name}"
  public_key = "${file(var.public_key_path)}"
}

## DB instances

resource "aws_db_instance" "db" {
  allocated_storage      = "${var.db_alloc_storage}"
  engine                 = "${var.db_engine}"
  engine_version         = "${var.db_engine_version}"
  instance_class         = "${var.db_instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.db_user}"
  password               = "${var.db_password}"
  db_subnet_group_name   = "${aws_db_subnet_group.rds_subnet_group.name}"
  vpc_security_group_ids = ["${aws_security_group.RDS.id}"]
}

## dev server


# ansible play


## load ballancer


## AMI


## Launch configuration


## Autoscaling group


### Route 53


## primary zone
# www
# dev
# db

