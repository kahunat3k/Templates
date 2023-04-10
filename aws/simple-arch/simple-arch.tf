# Brainboard auto-generated file.

resource "aws_vpc" "test-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    env      = "Test"
    archUUID = "caf71da3-4fa4-4d29-a59f-51d08bab49ad"
  }
}

resource "aws_subnet" "test-public-subnet" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    env      = "Test"
    archUUID = "caf71da3-4fa4-4d29-a59f-51d08bab49ad"
  }
}

resource "aws_instance" "test-server1" {
  subnet_id     = aws_subnet.test-public-subnet.id
  instance_type = "t2.micro"
  ami           = "ami-0c02fb55956c7d316"

  tags = {
    env      = "Test"
    archUUID = "caf71da3-4fa4-4d29-a59f-51d08bab49ad"
  }
}

resource "aws_instance" "test-server2" {
  subnet_id     = aws_subnet.test-public-subnet.id
  instance_type = "t2.micro"
  ami           = "ami-0c02fb55956c7d316"

  tags = {
    env      = "Test"
    archUUID = "caf71da3-4fa4-4d29-a59f-51d08bab49ad"
  }
}

