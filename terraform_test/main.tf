resource "aws_instance" "lab_instance" {
    ami = "ami-07891c5a242abf4bc"
    instance_type = "c5.4xlarge"
    key_name= "haneesh.cloud_keypair"
    subnet_id= aws_subnet.public_subnet1.id 
    vpc_security_group_ids = [aws_security_group.lab_sg.id]


    tags = {
        Name = "lab_instance"
    }
    
}

resource "aws_vpc" "lab_vpc"{
    cidr_block= "192.168.0.0/16"

    tags = {
        Name = "lab_vpc"
    }
}

resource "aws_subnet" "public_subnet1"{
    vpc_id= aws_vpc.lab_vpc.id
    cidr_block = "192.168.1.0/24"
    availability_zone= "ap-south-2a"
    map_public_ip_on_launch = true
    tags= {
        Name= "public_subnet1"
    }
}

resource "aws_subnet" "private_subnet1" {
    vpc_id = aws_vpc.lab_vpc.id
    cidr_block = "192.168.2.0/24"
    availability_zone = "ap-south-2b"
    map_public_ip_on_launch = true
    tags = {
        Name = "private_subnet1"
    }
}

resource "aws_internet_gateway" "lab_igw"{
    vpc_id = aws_vpc.lab_vpc.id
    tags = {
        Name = "lab_igw"
    }
}

resource "aws_route_table" "lab_route_table"{
    vpc_id = aws_vpc.lab_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id= aws_internet_gateway.lab_igw.id
    }

            tags = {
            Name= "lab_route_table"
        }
}

resource "aws_route_table_association" "public_subnet1_route_table" {
    subnet_id = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.lab_route_table.id
}

resource "aws_security_group" "lab_sg" {
    vpc_id = aws_vpc.lab_vpc.id

ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
}

ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
}

tags = {
    Name = "lab_sg"
}
}