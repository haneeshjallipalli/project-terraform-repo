terraform {
    backend "s3" {
        bucket = "my-terraform-backend-bucket-v36"
        key = "terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-locks-v36"
        encrypt = true
    }
}