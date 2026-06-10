resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "guipedroso-ecs-project"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "guipedroso-ecs-project-internet-gateway"
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.0.0/26"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "guipedroso-ecs-project-public-subnet-1a"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.0.64/26"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "guipedroso-ecs-project-public-subnet-1b"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.0.128/26"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "guipedroso-ecs-project-private-subnet-1a"
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.0.192/26"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "guipedroso-ecs-project-private-subnet-1b"
  }
}

resource "aws_eip" "this" {
  domain = "vpc"

  tags = {
    Name = "guipedroso-ecs-project-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public_1a.id

  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "guipedroso-ecs-project-nat-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "guipedroso-ecs-project-public-route-table"
  }
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "guipedroso-ecs-project-private-route-table"
  }
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private.id
}
