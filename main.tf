# Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
  # enable_dns_support   = true
  # enable_dns_hostnames = true

  tags = {
    Name = "myvpc"
  }
}

# Create a subnet sub1
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sub1-10.0.1.0/24-eu-west-2a"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "main-igw"
  }
}