/*
variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "0.0.0.0/0"
}
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
}
*/

variable "admin_password" {
  description = "Windows Administrator password to login as."
  default     = "DevOps2016"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default     = "gocd"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-2"
}

variable "ami_id" {
  description = "Target Ami ID"
}

variable "repo_url" {
  description = "source Git repo url"
}



provider "aws" {
  region = "${var.aws_region}"
}




resource "aws_instance" "ami_base" {
  ami           = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  security_groups = ["terraform_w3"]
  tags {
    Name = "TF_Linux"
  }
  
  user_data = <<HEREDOC
	  #!/bin/bash
	  sudo su
	  echo 'root:DevOps2016' | chpasswd
	HEREDOC


	provisioner "remote-exec" {
		connection {
			type	=	"ssh"
			user	=	"ec2-user"
			private_key = "${file("/etc/ssh/gocd.pem")}"
		}

		inline = [
			"sudo rm -rf /var/www/html",
			"sudo git clone ${var.repo_url} /var/www/html/",
		  "sudo service httpd start",
		  "sudo chkconfig httpd on",
		]
	  }
  
  provisioner "local-exec" {
    command = <<EOT
		echo $USER
		echo $USER > user.txt
		echo "PublicIp: ${aws_instance.ami_base.public_ip}" > info.txt
		echo "PrivateIp: ${aws_instance.ami_base.public_ip}" >> info.txt
		echo "InstanceId: ${aws_instance.ami_base.id}" >> info.txt
		echo ${aws_instance.ami_base.id} >> instanceId.txt
		echo "Done"
	EOT
  }
  
}

output "public_ip" {
  value = "${aws_instance.ami_base.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.ami_base.private_ip}"
}
