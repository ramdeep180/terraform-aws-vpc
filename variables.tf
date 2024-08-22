variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "amis" {
    description = "AMIs by region"
    default = {
    #     us-east-1 = "ami-97785bed" # ubuntu 14.04 LTS
		# us-east-2 = "ami-f63b1193" # ubuntu 14.04 LTS
		# us-west-1 = "ami-824c4ee2" # ubuntu 14.04 LTS
		# us-west-2 = "ami-f2d3638a" # ubuntu 14.04 LTS
    ap-west-1 = "ami-09aca7dc4472c6b75" #Database
    ap-west-1 = "ami-034f721aeec3398b2" #Application server
    ap-west-1 = "ami-0b614d2d81a3343f2" #Redis SERVER
    }
}
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "IGW_name" {}
variable "key_name" {}
variable "public_subnet1_cidr" {}
variable "public_subnet2_cidr" {}
variable "public_subnet3_cidr" {}
variable "private_subnet1_cidr" {}
variable "private_subnet2_cidr" {}
variable "private_subnet3_cidr" {}
variable "public_subnet1_name" {}
variable "public_subnet2_name" {}
variable "public_subnet3_name" {}
variable "private_subnet1_name" {}
variable "private_subnet2_name" {}
variable "private_subnet3_name" {}
variable Main_Routing_Table {}
variable Main_Routing_Table1 {}

variable "azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  type = "list"
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}
variable "cidr" {
  description = "CIDR block for the subnets"
  type = "list"
  default = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
}

variable "azs1" {
  description = "Run the EC2 Instances in these Availability Zones"
  type = "list"
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}
variable "cidr1" {
  description = "CIDR block for the subnets"
  type = "list"
  default = ["10.0.11.0/24", "10.0.21.0/24", "10.0.31.0/24"]
}

variable "environment" { default = "prod1" }
variable "env" {}
variable "instance_type" {
  type = "map"
  default = {
    # dev = "t2.nano"
    # test = "t2.micro"
    # prod = "t2.medium"
    prod1= "t4g.micro"
    }
}