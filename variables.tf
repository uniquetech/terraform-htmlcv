#VARIABLES DEV

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {}
variable "region" {
  default = "eu-west-1"
}

variable "network_address_space" {
  default = "10.1.0.0/16"
}

variable "environment" {}
variable "environment_tag" {}
variable "bucket_name" {}

variable "instance_count" {
  default = 2     
}

variable "subnet_count" {
  default = 2
}
