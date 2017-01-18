resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_iprange_prefix}.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "${var.name}"
    Role = "vpc"
  }
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.name}"
    Role = "igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.name}-public"
    Role = "public"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.vpc.id}"
}

resource "aws_subnet" "public_0" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.vpc_iprange_prefix}.0/28"
  availability_zone       = "${var.az[0]}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.name}-public_${var.az[0]}"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.vpc_iprange_prefix}.16/28"
  availability_zone       = "${var.az[1]}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.name}-public_${var.az[1]}"
  }
}

resource "aws_route_table_association" "public_0" {
  subnet_id      = "${aws_subnet.public_0.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = "${aws_subnet.public_1.id}"
  route_table_id = "${aws_route_table.public.id}"
}
