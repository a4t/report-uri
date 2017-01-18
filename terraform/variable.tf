provider "aws" {
  region = "ap-northeast-1"
}

variable "name" {}

variable "vpc_iprange_prefix" {}

variable "developer_ips" {
  default = []
}

variable "ingress_port" {
  default = []
}

variable "enable_dns_hostnames" {
  default = true
}

variable "enable_dns_support" {
  default = true
}

variable "az" {
  default = []
}

variable "instance" {
  default = {
    ami_id       = ""
    type         = ""
    key_name     = ""
    server_count = ""
  }
}

variable "ssl_certificate_id" {}

variable "route53" {
  default = {
    zone_id = ""
    domain  = ""
  }
}

variable "slack_webhook_url" {}
