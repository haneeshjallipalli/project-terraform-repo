resource "aws_instance" "ec2_machine" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = "default_vm"

    vpc_security_group_ids= [var.security_group_id]

    tags = {
        Name = "Terraform_ec2_instance"
    }
}

resource "aws_s3_bucket" "terraform_backend" {
    bucket = "my-terraform-backend-bucket-v36"
    acl = "private"

    versioning {
        enabled = true
    }

    lifecycle {
        #prevent_destroy = true
    }

    tags = {
        Name = "terraform-backend-bucket"
    }
}

resource "aws_dynamodb_table" "dynamodb_locking_for_s3" {
    name = "terraform-locks-v36"
    billing_mode = "PAY_PER_REQUEST"
    hash_key= "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }

    lifecycle{
        #prevent_destroy = true
    }

    tags = {
        Name = "dynamodb_locking_for_s3"
    }
}