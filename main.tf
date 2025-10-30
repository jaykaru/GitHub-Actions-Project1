# Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
  # enable_dns_support   = true
  # enable_dns_hostnames = true

  tags = {
    Name = "myvpc"
  }
}