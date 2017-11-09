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
