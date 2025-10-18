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


resource "aws_instance" "terraform_test_instance"{
    ami = "ami-04b4f1a9cf54c11d0"
    instance_type = "t2.medium"
    key_name = "default_vm"

    # Attach Security Group
    vpc_security_group_ids = ["sg-006d59c0eb1c5a294"]

    tags = {
        Name = "Lab_Server"
    }
}