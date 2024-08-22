resource "aws_instance" "web-1" {
#    ami = "${data.aws_ami.my_ami.id}"
    count= "${var.env == "prod" ? 3 : 1}"          ###"${condition ? 3 : 1}"
    ami = "ami-0d857ff0f5fc4e03b"
#    availability_zone = "ap-south-1"
    instance_type = "t4g.micro"
    key_name = "terraform"
    subnet_id = "${element(aws_subnet.subnets.*.id, count.index)}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    tags = {
        Name = "Server-${count.index+1}"
        #Name = "Web-Server"
        Env = "Prod"
        Owner = "Ram"
    }
}



