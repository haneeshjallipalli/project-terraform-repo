terraform {
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~>5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
    # acess_key = "your_access_key"
    # secret_key = "your_secret_key"

}


resource "aws_instance" "control_instance"{
    ami = "ami-04b4f1a9cf54c11d0"
    instance_type = "t2.micro"
    key_name = "default_vm"

    # Attach Security Group
    vpc_security_group_ids = ["sg-006d59c0eb1c5a294"]

    tags = {
        Name = "ansible_control_node"
    }
}

resource "aws_instance" "worker_instance"{
    ami = "ami-04b4f1a9cf54c11d0"
    instance_type = "t2.micro"
    key_name = "default_vm"

    # Attach Security Group
    vpc_security_group_ids = ["sg-006d59c0eb1c5a294"]

    tags = {
        Name = "ansible_worker_node"
    }
}
