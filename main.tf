resource "aws_vpc" "new_vpc" {
  cidr_block = var.cidr
  tags = {
    Name = "Terraform-VPC"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.new_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Terraform-sub1"
  }
  
}
resource "aws_subnet" "sub2" {
  vpc_id = aws_vpc.new_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Terraform-sub2"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.new_vpc.id
    tags = {
    Name = "Terraform-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.new_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
    tags  = {
    Name = "Terraform-rt"
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {
  name = "web-sg"
  vpc_id = aws_vpc.new_vpc
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
      Name = web-sg
    }
}