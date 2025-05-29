resource "aws_security_group" "Main_sg" {
  name = "Main security group"
  description = "Main security group"
}

resource "aws_vpc_security_group_ingress_rule" "main_sg_ingress1" {
  security_group_id = aws_security_group.Main_sg.id
  cidr_ipv4 = join("/", [trimspace(data.http.my_ip.response_body), "32"])
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "main_sg_egress1" {
  security_group_id = aws_security_group.Main_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_instance" "TestLamda" {
    tags = {
      Name = "TestLamda"
    }
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [ aws_security_group.Main_sg.id ]
    associate_public_ip_address = true
    key_name = var.key_name
}

resource "null_resource" "Hardening" {
    triggers = {
      always_run = timestamp()
    }
    provisioner "local-exec" {
        command = "ansible-playbook -i ${aws_instance.TestLamda.public_ip}, ansible/main.yaml --private-key $KEY -u admin -vvv"
    }
}