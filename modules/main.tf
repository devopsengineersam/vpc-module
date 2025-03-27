data "aws_availability_zones" "available" {
  state = "available"
  
  filter {
    name   = "zone-type"
    values = ["availability-zone"]  # Exclude local zones
  }
}

data "aws_region" "current" {}

resource "aws_vpc" "prisma_vpc" {
  cidr_block = var.vpc_cidr
  tags = merge(var.tags, {
    Name = "${var.name}-vpc-${data.aws_region.current.name}",
    Environment = "${var.environment}"
  })
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.prisma_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 2, 1)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${var.name}-public-subnet-${data.aws_region.current.name}",
    Environment = "${var.environment}"
  })
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.prisma_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 2, 2)
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = merge(var.tags, {
    Name = "${var.name}-private-subnet-${data.aws_region.current.name}",
    Environment = "${var.environment}"
  })
}

resource "aws_security_group" "https_sg" {
  name        = "prisma-https-sg"
  description = "Allow HTTPS outbound traffic"
  vpc_id      = aws_vpc.prisma_vpc.id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-https-sg",
    Environment = "${var.environment}"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prisma_vpc.id
  tags = merge(var.tags, {
    Name = "${var.name}-igw",
    Environment = "${var.environment}"
  })
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = merge(var.tags, {
    Name = "${var.name}-nat-eip",
    Environment = "${var.environment}"
  })
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = merge(var.tags, {
    Name = "${var.name}-nat-gw",
    Environment = "${var.environment}"
  })
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.prisma_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.name}-public-rt",
    Environment = "${var.environment}"
  })
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.prisma_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = merge(var.tags, {
    Name = "${var.name}-private-rt",
    Environment = "${var.environment}"
  })
}

resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.prisma_vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_rt.id]
  tags = merge(var.tags, {
    Name = "${var.name}-s3-vpc-endpoint",
    Environment = "${var.environment}"
  })
}