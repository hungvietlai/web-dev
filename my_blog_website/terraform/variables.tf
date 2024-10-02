variable "aws_region" {
  description = "The AWS region where the resources will be created."
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC, defining the IP address range."
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet, a smaller range within the VPC."
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "The availability zone in the specified AWS region where the subnet will be created."
  default     = "us-east-1a"
}

variable "public_key_path" {
  description = "The path to the public SSH key to be used for EC2 access."
  default     = "~/.ssh/blog_app.pub"
}

variable "ec2_ami" {
  description = "The Amazon Machine Image (AMI) ID to use for the EC2 instance. This specifies the OS and base software."
  default     = "ami-0e86e20dae9224db8"
}

variable "ec2_instance_type" {
  description = "The EC2 instance type that defines the compute capacity (e.g., t3.micro for general-purpose low-cost instances)."
  default     = "t3.micro"
}
