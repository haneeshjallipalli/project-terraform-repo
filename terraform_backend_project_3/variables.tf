variable "ami_id" {
    type = string
    default = "ami-04b4f1a9cf54c11d0"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "security_group_id" {
    type = string 
    default = "sg-006d59c0eb1c5a294"
}