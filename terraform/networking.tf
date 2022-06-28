############################################################

resource "aws_vpc" "sos_vpc" {
  cidr_block           = "${var.sos_cidr}.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

############################################################

resource "aws_internet_gateway" "sos_igw" {
  vpc_id = aws_vpc.sos_vpc.id
  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

############################################################

resource "aws_subnet" "sos_private_subnet" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.sos_vpc.id
  cidr_block        = "${var.sos_cidr}.${8 + (count.index) * 8}.0/21"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name    = "private-${var.cluster_name}"
    Network = "private"
  }
}

resource "aws_subnet" "sos_public_subnet" {
  count             = length(data.aws_availability_zones.available.names)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "${var.sos_cidr}.${1 + count.index}.0/24"
  vpc_id            = aws_vpc.sos_vpc.id

  tags = {
    Name    = "public-${var.cluster_name}"
    Network = "public"
  }
}

############################################################

resource "aws_route_table" "sos_private_route_table" {
  count  = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.sos_vpc.id

  tags = {
    Name    = "private-${var.cluster_name}"
    Network = "private"
  }
}

resource "aws_route_table_association" "private_rt_association" {
  count          = length(data.aws_availability_zones.available.names)
  route_table_id = aws_route_table.sos_private_route_table[count.index].id
  subnet_id      = aws_subnet.sos_private_subnet[count.index].id
}

resource "aws_route_table" "sos_public_route_table" {
  count  = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.sos_vpc.id

  tags = {
    Name    = "public-${var.cluster_name}"
    Network = "public"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count          = length(data.aws_availability_zones.available.names)
  route_table_id = aws_route_table.sos_public_route_table[count.index].id
  subnet_id      = aws_subnet.sos_public_subnet[count.index].id
}

############################################################

resource "aws_eip" "sos_eip" {
  count = length(data.aws_availability_zones.available.names)
  tags = {
    Name = "${var.cluster_name}-eip"
  }
}

############################################################

resource "aws_nat_gateway" "sos_public_egress" {
  count         = length(data.aws_availability_zones.available.names)
  allocation_id = aws_eip.sos_eip[count.index].id
  subnet_id     = aws_subnet.sos_public_subnet[count.index].id

  tags = {
    Name = "${var.cluster_name}-nat-gateway"
  }
}

############################################################

resource "aws_route" "sos_internet_gateway" {
  count                  = length(data.aws_availability_zones.available.names)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sos_igw.id
  route_table_id         = aws_route_table.sos_public_route_table[count.index].id
}

resource "aws_route" "sos_private_egress" {
  count                  = length(data.aws_availability_zones.available.names)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.sos_public_egress[count.index].id
  route_table_id         = aws_route_table.sos_private_route_table[count.index].id
}

############################################################

resource "aws_security_group" "sos_sg_ecs" {
  name   = "sos Task ecs task"
  vpc_id = aws_vpc.sos_vpc.id
}

############################################################