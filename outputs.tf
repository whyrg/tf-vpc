output "subnet" {
  description = "The first subnet of this vpc"
  value = "aws_subnet.az[0].id" 
}

output "name" {
  description = "The name of this vpc"
  value ="Terraform-var.client-var.environment"
}
