terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tf-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  count = 2
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = cidrsubnet(aws_vpc.main-vpc.cidr_block,8,count.index)
  tags = {
    Name="tf-public-${count.index}"
  }
}

resource "aws_subnet" "private-subnet" {
  count = 2
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = cidrsubnet(aws_vpc.main-vpc.cidr_block,8,length(aws_subnet.public-subnet)+count.index)
  tags = {
    Name="tf-private-${count.index}"
  }
}