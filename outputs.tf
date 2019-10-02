output "subnet" {
  description = "The first subnet of this vpc"
  value = "${aws_subnet.az.0.id}" 
}

#output "security_group_ids" {
#  value =  ["${aws_security_group.allow_vpn.id}"]
#}
#
