data "aws_availability_zones" "available" {}

# NETWORKING

provider "aws" {
  version = "~> 2.0"
  region = "${var.region}"
  access_key = "${var.scalr_aws_access_key}"
  secret_key = "${var.scalr_aws_secret_key}"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Terraform-${var.client}-${var.environment}"
    CreatedBy = "Terraform"
    AppTeam = "${var.team}"
    Client = "${var.client}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "az" {
  count = "${length(data.aws_availability_zones.available.names)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block = "${cidrsubnet(var.cidr,8,count.index)}"
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    CreatedBy = "Terraform"
    AppTeam = "${var.team}"
    Client = "${var.client}"
    Environment = "${var.environment}"
  }  
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    CreatedBy = "Terraform"
    AppTeam = "${var.team}"
    Client = "${var.client}"
    Environment = "${var.environment}"
  }
}


resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    CreatedBy = "Terraform"
    AppTeam = "${var.team}"
    Client = "${var.client}"
    Environment = "${var.environment}"
  }
}

resource "aws_main_route_table_association" "m" {
  vpc_id         = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.r.id}"
}
resource "aws_network_acl" "main" {
  vpc_id = "${aws_vpc.main.id}"
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 101
    action     = "allow"
    ipv6_cidr_block = "::/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "-1"
    rule_no    = 101
    action     = "allow"
    ipv6_cidr_block = "::/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    CreatedBy = "Terraform"
    AppTeam = "${var.team}"
    Client = "${var.client}"
    Environment = "${var.environment}"
  }
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    CreatedBy = "Terraform"
    AppTeam = "${var.team}"
    Client = "${var.client}"
    Environment = "${var.environment}"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
}


