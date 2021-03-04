variable "instance_name" {
  type        = string
  default     = "ExampleInstance"
  description = "Value of the Name tag for the EC2 instance"
}

variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for VPC"
}
 
variable "instance_count" {
   type        = number
   default     = ""
   description = "Number of instances to provision"
}

variable "enable_vpn_gateway" {
    description = "Enable a VPN in your VPC"
    type = bool
    default = false
}

variable "public_subnet_count" {
    description = "number of public subnets"
    type = number
    default = 2
}

variable "private_subnet_count" {
    description = "number of private subnets"
    type = number
    default = 2
}

variable "public_subnet_cidr_blocks" {
    description = "Available cidr blocks for public subnets"
    type = list(string)
    default = [
        "10.0.1.0/24",
        "10.0.2.0/24",
        "10.0.3.0/24",
        "10.0.4.0/24",
        "10.0.5.0/24",
        "10.0.6.0/24",
        "10.0.7.0/24",
        "10.0.8.0/24",
    ]
}

variable "private_subnet_cidr_blocks" {
    description = "Available cidr blocks for private subnets"
    type = list(string)
    default = [
        "10.0.101.0/24",
        "10.0.102.0/24",
        "10.0.103.0/24",
        "10.0.104.0/24",
        "10.0.105.0/24",
        "10.0.106.0/24",
        "10.0.107.0/24",
        "10.0.108.0/24",
    ]
}

variable "resource_tags" {
    description = "tages to set to all resources"
    type = map(string)
    default = {
        project = "project-x"
        environment = "dev"
    }
}

validation {
    condition = length(var.resource_tags["project"]) <=16 && length(regexall("/[^a-zA-Z0-9-]/".var.resource_tags["project"])) == 0
    description = "project tag should be less than 16 chars long and must contain letters,numbers and hypherns"

}

validation {
    condition = length(var.resource_tags["environment"]) <=8 && length(regexall("/[^a-zA-Z0-9-]/".var.resource_tags["project"])) == 0
    description = "environment tag should be less than 8 chars long and must contain letters,numbers and hypherns"

}

/*
terraform apply -var='resource_tags={project="project-x",environment="var"}
*/

variable "ec2_instance_type" {
    description = "AWS EC2 instance type"
    type = string
}

variable "db_username" {
    description = "Database administrator username"
    type = string
    sensitive = true
}

variable "db_password" {
    description = "Database administrator password"
    type = string
    sensitive = true
}