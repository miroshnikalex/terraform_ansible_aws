variable "aws_region" {
  default = "eu-central-1"
}

variable "aws_profile" {
  default = "default"
}

variable "aws_custom_vpc" {
  default = "main"
}

variable "aws_cidr_block" {
  default = "10.1.0.0/16"
}

variable "aws_custom_igw" {
  default = "default_igw"
}

variable "public_cidr" {
  default = "0.0.0.0/0"
}
