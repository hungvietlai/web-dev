terraform {
  required_version = "<= 1.9.5"
}

# Specify the provider
provider "aws" {
  region = var.aws_region
}

# Creating VPC
resource "aws_vpc" "blog_app_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Creating a Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.blog_app_vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "blog-app-subnet"
  }
}

# Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.blog_app_vpc.id

  tags = {
    Name = "blog-app-igw"
  }
}

# Create a route table for the VPC
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.blog_app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Creating Security Group
resource "aws_security_group" "my_sg" {
  name   = "blog-app-sg"
  vpc_id = aws_vpc.blog_app_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "ssh_rule" {
  security_group_id = aws_security_group.my_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0" # Allow SSH from any IPv4 address
}

resource "aws_vpc_security_group_ingress_rule" "app_rule" {
  security_group_id = aws_security_group.my_sg.id
  ip_protocol       = "tcp"
  from_port         = 3000
  to_port           = 3000
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "outbound_rule" {
  security_group_id = aws_security_group.my_sg.id
  ip_protocol       = "-1"
  from_port         = 0
  to_port           = 0
  cidr_ipv4         = "0.0.0.0/0"
}

# Create key pair for ssh
resource "aws_key_pair" "blog_app_key" {
  key_name   = "blog_app_key"
  public_key = file("${var.public_key_path}")
}

#Create EC2 Instance
resource "aws_instance" "blog_app_node" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.my_subnet.id
  vpc_security_group_ids      = [aws_security_group.my_sg.id]
  key_name                    = aws_key_pair.blog_app_key.key_name
  associate_public_ip_address = true # Enable IPV4

  user_data = <<-EOF
        #!/bin/bash
        # Install updates and Docker

        sudo apt-get update
        sudo apt-get install -y docker.io
        sudo systemctl start docker
        sudo systemctl enable docker

        # Pull Docker image from DockerHub
        sudo docker pull hungvietlai/blog-app

        # Run Docker container
        sudo docker run -d -p 3000:3000 hungvietlai/blog-app
    EOF
}

# Output the public IP
output "blog_app_public_ip" {
  value = aws_instance.blog_app_node.public_ip
}

output "public_DNS" {
value = aws_instance.blog_app_node.public_dns
}





