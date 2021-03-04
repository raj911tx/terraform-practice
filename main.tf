locals {
  //name_suffix = "${var.resource_tags["project"]}-${var.resource_tags["environment"]}"
    name_suffix = "${var.project_name}-${var.environment}"
}

locals {
    required_tags = {
        project = var.project_name
        environment = var.environment
    }
    tags = merge(var.resource_tags,local.required_tags)

}

terraform {
    required_providers {
      aws = {
        source = "hasicorp/aws"
        version = "~> 3.27"
      }
    }
}
provider "aws" {
    profile = "default"
    //region = "us-west-2"
    region = var.aws_region
}

resource "aws_instance" "web"   {
    ami = "ami-830c94c3"
    //instance_type = "t2.micro"
    instance_type = var.ec2_instance_type
    user_data = file("init-script.sh")
    vpc_security_group_ids = [aws_security_group.web-sg.id]

    tags = {
        Name =  random_pet.name.id
    }
}
resource "random-pet" "name" {}

resource "aws_security_group" "web-sg" {
    name = "${random-pet.name.id}-sg"
    ingress {
        from_port = 80
        tp_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    /*
    tags = {
        project = "project-x"
        environment = "dev"
    }
    */
    
    //tags = var.resource_tags
    tags = local.tags
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "2.66.0"
    //name = "vpc-${var.resource_tags["project"]}-${var.resource_tags["environment"]}"
    name = "vpc-${local.name_suffix}"
    //azs = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e"]
    azs = data.aws_availability_zones.available.names
    
    //cidr = 10.0.0.0/16
    cidr = var.vpc_cidr_block
    enable_nat_gateway = true
    //enable_vpn_gateway = false
    enable_vpn_gateway = var.enable_vpn_gateway
    azs = data.aws_availability_zones.available.names
    //private_subnets = ["10.0.101.0/24","10.0.102.0/24"]
    //public_subnets = ["10.0.1.0/24","10.0.2.0/24"]
    private_subnets = slice(var.private_subnet_cidr_blocks,0,var.private_subnet_count)
    public_subnets = slice(var.public_subnet_cidr_blocks,0,var.private_subnet_count)
}

module "ec2_instances" {
    source = "./modules/aws-instance"
    //instance_count = 2
    instance_count = var.instance_count
}
 module "app_security_group" {
     source = "terraform-aws-modules/security-group/aws//modules/web"
     version = "3.12.0"
    
    //name = "web-sg-project-x-dev"
    //name = "web-sg-${var.resource_tags["project"]}-${var.resource_tags["environment"]}"
    name = "web-sg-${local.name_suffix}"

}

resource "aws_db_instance" "database" {
    allocated_storage = 5
    engine = "mysql"
    instance_class = "db.t2.micro"
    //username = "admin"
    //password = "password"
    username = var.db_username
    password = var.db_password
}

data "aws_availability_zones" "available" {
    state = "available"
}

data "aws_region" "current" { }