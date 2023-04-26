resource "aws_vpc" "primary" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "primary-vpc"
  }
}

resource "aws_subnet" "primary" {
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "primary-subnet"
  }
}

resource "aws_subnet" "primary" {
  count             = 3
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = "us-west-1${char(96 + count.index + 1)}"

  tags = {
    Name = "primary-subnet-${count.index}"
  }
}

resource "aws_security_group" "aurora" {
  name_prefix = "aurora-db-sg"
  description = "Security group for Aurora Serverless database"

  ingress {
    from_port   = 3306
    to_port     = 3306
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
    Name = "aurora-db-sg"
  }
}

resource "aws_db_subnet_group" "aurora" {
  name        = "aurora-db-subnet-group"
  subnet_ids  = [aws_subnet.primary.*.id]
  description = "Subnet group for Aurora Serverless database"
}