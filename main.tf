provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

### IAM

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

### SGs


## Private


## Public


## RDS


### S3 code bucket


### Compute resources


## key pair


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

