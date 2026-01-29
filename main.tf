# Standard Terraform configuration for a VPC with dynamic subnets
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.76.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Define Local variables for CIDR management
locals {
  aws_vpc_cidr = "192.168.0.0/16"
}

# 2. Fetch all active Availability Zones for the specified region
data "aws_availability_zones" "available" {
  state = "available"
}

# 3. Create the Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
  cidr_block           = local.aws_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "dev-vpc"
    Environment = "Dev"
  }
}

# 4. Create Dynamic Subnets across all available Availability Zones
resource "aws_subnet" "main" {
  # Iterates through every AZ found in Step 2
  for_each = toset(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value
  
  # Logic: cidrsubnet(prefix, newbits, netnum)
  # Splits the /16 into /24 subnets based on the AZ index
  cidr_block = cidrsubnet(
    aws_vpc.main.cidr_block,
    8,
    index(data.aws_availability_zones.available.names, each.value)
  )

  tags = {
    Name        = "dev-subnet-${each.value}"
    Environment = "Dev"
  }
}

# 5. Optional: Output the VPC ID for easy reference
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "dev-rt"
  }
}


resource "aws_route_table_association" "main" {
  for_each = aws_subnet.main
  subnet_id = each.value.id
  route_table_id = aws_route_table.main.id
}