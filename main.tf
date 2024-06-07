provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = var.tags
}

resource "aws_subnet" "pb_subnet" {
  count = length(var.pb_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pb_subnet_cidrs[count.index]
  availability_zone = var.zones[count.index]

  tags = merge(var.subnet_tags, { Name = "${var.subnet_tags.Name}-public-${var.zones[count.index]}" })
}

resource "aws_subnet" "pv_subnet" {
  count = length(var.pv_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pv_subnet_cidrs[count.index]
  availability_zone = var.zones[count.index]

  tags = merge(var.subnet_tags, { Name = "${var.subnet_tags.Name}-private-${var.zones[count.index]}" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = var.igw_tags
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pb_subnet[0].id

  tags = var.natgw_tags
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = var.natgw_tags
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = var.public_route_table_tags
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = var.private_route_table_tags
}

resource "aws_route_table_association" "public_rta" {
  count          = length(var.pb_subnet_cidrs)
  subnet_id      = aws_subnet.pb_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rta" {
  count          = length(var.pv_subnet_cidrs)
  subnet_id      = aws_subnet.pv_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_db_subnet_group" "postgressql_subnet_group" {
  name = "reviews-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.pv_subnet : subnet.id]
  
  tags = var.db_subnet_group_tag
}

resource "random_shuffle" "pb_subnet_shuffle" {
  input        = aws_subnet.pb_subnet[*].id
  result_count = 1
}
