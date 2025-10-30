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

# Create a Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associate the Route Table with the Subnets
resource "aws_route_table_association" "sub1_assoc" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a Security Group
resource "aws_security_group" "websg" {
  name        = "websg"
  description = "Allow HTTP, HTTPS, and SSH"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "websg"
  }
}

# Create an EC2 Instance
resource "aws_instance" "web_one" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data_base64       = base64encode(file("userdataweb1.sh"))
  # associate_public_ip_address = true
  #key_name               = "mykeypair"  # Ensure this key pair exists in the specified region

  tags = {
    Name = "web-one-ec2"
  }
}