resource "aws_vpc" "eks_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "eks_vpc"
    }
}

resource "aws_subnet" "public_subnet_1" {
    vpc_id                  = aws_vpc.eks_vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "public_subnet_1"
    }
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id                  = aws_vpc.eks_vpc.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "public_subnet_2"
    }
}

# igw for public_subnets
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.eks_vpc.id

    tags = {
        Name = "igw"
    }
}

# route table for public_subnets
resource "aws_route_table" "route_table_public_subnets" {
    vpc_id = aws_vpc.eks_vpc.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "route_table_public_subnets"
    }
}

# Associate Public Route Table with Public Subnet 1
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_table_public_subnets.id
}

# Associate Public Route Table with Public Subnet 2
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.route_table_public_subnets.id
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "EKS cluster security group"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg"
  }
}
