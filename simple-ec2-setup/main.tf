# ------------------------------
# Create a new VPC
# ------------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc"
  }
}

# ------------------------------
# Create a subnet
# ------------------------------
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"

  tags = {
    Name = "terraform-subnet"
  }
}

# ------------------------------
# Internet Gateway
# ------------------------------
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-igw"
  }
}

# ------------------------------
# Route Table
# ------------------------------
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "terraform-rt"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}


# ------------------------------
# Security Group (open all ports)
# ------------------------------
resource "aws_security_group" "open_all" {
  name        = "open-all-sg"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow all inbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# ------------------------------
# EC2 Key Pair (optional)
# ------------------------------
# Create or reference your own key pair to SSH in
resource "aws_key_pair" "default" {
  key_name   = "tf-ec2-key"
  public_key = file(var.public_key) # ensure this file exists
}

# ------------------------------
# EC2 Instance
# ------------------------------
resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.open_all.id]
  key_name               = aws_key_pair.default.key_name

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "Terraform-Ubuntu-Instance"
  }
}

# ------------------------------
# Get latest Ubuntu AMI
# ------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}