# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "week4-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "week4-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "week4-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "week4-igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "week4-nat-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "week4-nat-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "week4-public-rt"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "week4-private-rt"
  }
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Public Web Security Group
resource "aws_security_group" "public_web" {
  name        = "week4-public-web-sg"
  description = "Security group for public web server"
  vpc_id      = aws_vpc.main.id

  # HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  # SSH from break-glass IP only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
    description = "Allow SSH from break-glass IP only"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "week4-public-web-sg"
  }
}

# Private Admin Security Group
resource "aws_security_group" "private_admin" {
  name        = "week4-private-admin-sg"
  description = "Security group for private admin server"
  vpc_id      = aws_vpc.main.id

  # NO INBOUND RULES - Access via SSM only

  # Allow all outbound traffic (for NAT Gateway updates)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "week4-private-admin-sg"
  }
}

# SSH Key Pair for Break-Glass Access
resource "aws_key_pair" "week4" {
  key_name   = "week4-key"
  public_key = file("~/.ssh/week4-key.pub")

  tags = {
    Name = "week4-key"
  }
}

# IAM Instance Profile (wraps the IAM role for EC2 use)
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "week4-ssm-instance-profile"
  role = "Week4-EC2-SSM-Role"
}

# Public Web Server EC2 Instance
resource "aws_instance" "public_web" {
  ami                    = "ami-06e3c045d79fd65d9"  # Replace with your AMI ID
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public_web.id]
  key_name               = aws_key_pair.week4.key_name
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "week4-public-web"
  }
}

# Private Admin Server EC2 Instance
resource "aws_instance" "private_admin" {
  ami                    = "ami-06e3c045d79fd65d9"  # Replace with your AMI ID
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_admin.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "week4-private-admin"
  }
}

