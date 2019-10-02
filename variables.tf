variable "environment" {
  type = "string"
  default = "dev"
}

variable "cidr" {
  type = "string"
  default = "172.18.0.0/16"
  description = "The CIDR of your VPC. default: 172.18.0.0/16. Each subnet is 8 additional bits masked incrementally: eg 172.18.1.0/32. 172.18.2.0/32..."
}

variable "team" {
  type = "string"
  default = "TCG"
}


variable "client" {
  type = "string"
  default = "TCG"
}

variable "region" {
  type = "string"
}

variable "scalr_aws_secret_key" {}
variable "scalr_aws_access_key" {}

