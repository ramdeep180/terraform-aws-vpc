#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
	tags = {
        Name = "${var.IGW_name}"
    }
}


resource "aws_subnet" "subnets" {
    count = 3
    vpc_id = "${aws_vpc.default.id}"
    availability_zone = "${element(var.azs, count.index)}"
    cidr_block = "${element(var.cidr, count.index)}"
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.vpc_name}_Public_subnet-${count.index+1}"
    }
 }

resource "aws_subnet" "subnets1" {
    count = 3
    vpc_id = "${aws_vpc.default.id}"
    availability_zone = "${element(var.azs1, count.index)}"
    cidr_block = "${element(var.cidr1, count.index)}"
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.vpc_name}_Private_subnet-${count.index+1}"
    }
 }



# resource "aws_subnet" "subnet1-public" {
#     vpc_id = "${aws_vpc.default.id}"
#     cidr_block = "${var.public_subnet1_cidr}"
#     availability_zone = "ap-south-1a"
#     map_public_ip_on_launch = true
#     tags = {
#         Name = "${var.public_subnet1_name}"
#     }
# }

# resource "aws_subnet" "subnet2-public" {
#     vpc_id = "${aws_vpc.default.id}"
#     cidr_block = "${var.public_subnet2_cidr}"
#     availability_zone = "ap-south-1b"
#     map_public_ip_on_launch = true
#     tags = {
#         Name = "${var.public_subnet2_name}"
#     }
# }

# resource "aws_subnet" "subnet3-public" {
#     vpc_id = "${aws_vpc.default.id}"
#     cidr_block = "${var.public_subnet3_cidr}"
#     availability_zone = "ap-south-1c"
#     map_public_ip_on_launch = true
#     tags = {
#         Name = "${var.public_subnet3_name}"
#     }
	
# }


# resource "aws_subnet" "subnet1-private" {
#     vpc_id = "${aws_vpc.default.id}"
#     cidr_block = "${var.private_subnet1_cidr}"
#     availability_zone = "ap-south-1a"
#     map_public_ip_on_launch = true
#     tags = {
#         Name = "${var.private_subnet1_name}"
#     }
	
# }


# resource "aws_subnet" "subnet2-private" {
#     vpc_id = "${aws_vpc.default.id}"
#     cidr_block = "${var.private_subnet2_cidr}"
#     availability_zone = "ap-south-1b"
#     map_public_ip_on_launch = true
#     tags = {
#         Name = "${var.private_subnet2_name}"
#     }
	
# }


# resource "aws_subnet" "subnet3-private" {
#     vpc_id = "${aws_vpc.default.id}"
#     cidr_block = "${var.private_subnet3_cidr}"
#     availability_zone = "ap-south-1c"
#     map_public_ip_on_launch = true
#     tags = {
#         Name = "${var.private_subnet3_name}"
#     }
	
# }



resource "aws_route_table" "terraform-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags = {
        Name = "${var.Main_Routing_Table}"
    }
}


resource "aws_route_table" "terraform-private" {
    vpc_id = "${aws_vpc.default.id}"
    tags = {
        Name = "${var.Main_Routing_Table1}"
    }
}


resource "aws_route_table_association" "terraform-private" {
    count=3
    subnet_id = "${element(aws_subnet.subnets1.*.id, count.index)}"
    route_table_id = "${aws_route_table.terraform-private.id}"
}

resource "aws_route_table_association" "terraform-public" {
    count=3
    subnet_id = "${element(aws_subnet.subnets.*.id, count.index)}"
    route_table_id = "${aws_route_table.terraform-public.id}"
}



# resource "aws_route_table_association" "terraform-public" {
# #    count="${length(var.cidr)}"
#     count=3
#     subnet_id = "${element(aws_subnet.subnets1.*.id, count.index)}"
#     route_table_id = "${aws_route_table.terraform-public.id}"
# }


# resource "aws_route_table_association" "terraform-public" {
#     subnet_id = "${aws_subnet.subnets.*.id}"
#     route_table_id = "${aws_route_table.terraform-public.id}"
# }



resource "aws_security_group" "allow_all" {
  name        = "college_sg"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}

data "aws_ami" "my_ami" {
     most_recent      = true
     #name_regex       = "ram"
     owners           = ["519779824038"]
}



#output "ami_id" {
#  value = "${data.aws_ami.my_ami.id}"
#}
#!/bin/bash
# echo "Listing the files in the repo."
# ls -al
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Packer Now...!!"
# packer build -var 'aws_access_key=AAAAAAAAAAAAAAAAAA' -var 'aws_secret_key=BBBBBBBBBBBBB' packer.json
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Terraform Now...!!"
# terraform init
# terraform apply --var-file terraform.tfvars -var="aws_access_key=AAAAAAAAAAAAAAAAAA" -var="aws_secret_key=BBBBBBBBBBBBB" --auto-approve
