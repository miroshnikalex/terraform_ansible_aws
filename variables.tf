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

variable "localip" {
  default = "0.0.0.0/0"
}

variable "db_alloc_storage" {
  default = "20"
}

variable "db_engine_version" {
  default = "10.1.23"
}

variable "db_engine" {
  default = "mariadb"
}

variable "db_instance_class" {
  default = "db.t2.micro"
}

variable "db_name" {
  default = "test"
}

variable "db_user" {
  default = "test"
}

variable "db_password" {
  default = "test"
}

variable "key_pair_name" {
  default = "terraform"
}

variable "public_key_path" {
  default = ""
}

variable "domain_name" {
  default = ""
}

variable "dev_instance_type" {
  default = "t2.micro"
}

variable "dev_ami" {
  default = ""
}

variable "elb_healthy_threshold" {
  default = "5"
}

variable "elb_unhealthy_threshold" {
  default = "5"
}

variable "healthcheck_timeout" {
  default = "5"
}

variable "healthcheck_interval" {
  default = "5"
}

variable "lc_instance_type" {
  default = "t2.micro"
}

variable "asg_max_size" {
  default = "3"
}

variable "asg_min_size" {
  default = "1"
}

variable "asg_grace" {
  default = ""
}

variable "asg_check_type" {
  default = ""
}

variable "asg_desired_capacity" {
  default = ""
}
