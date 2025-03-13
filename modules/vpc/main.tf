resource "aws_vpc" "eks-vpc" {
	cidr_block = var.vpc_cidr_block
	enable_dns_support = true
	enable_dns_hostnames = true
	tags = {
		Name = "${var.cluster_name}-vpc"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	}

}

resource "aws_subnet" "private" {
	count = length(var.private-subnet-cidrs)
	vpc_id = aws_vpc.eks-vpc.id
	cidr_block = var.private-subnet-cidrs[count.index]
	availability_zone = element(var.availability_zones, count.index)
	map_public_ip_on_launch = false

	tags = {
		Name = "${var.cluster_name}-private-${count.index}"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
		"kubernetes.io/role/internal-elb" = "1"
	}

}

resource "aws_subnet" "public" {
	count = length(var.public-subnet-cidrs)
	vpc_id = aws_vpc.eks-vpc.id
	cidr_block = var.public-subnet-cidrs[count.index]
	availability_zone = element(var.availability_zones, count.index)
	map_public_ip_on_launch = true

	tags = {
		Name = "${var.cluster_name}-public-${count.index}"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
		"kubernetes.io/role/elb" = "1"
	}

}

resource "aws_internet_gateway" "eks-igw" {
	vpc_id = aws_vpc.eks-vpc.id
	tags = {
		Name = "${var.cluster_name}-igw"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	}

}

resource "aws_route_table" "eks-public" {
	vpc_id = aws_vpc.eks-vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.eks-igw.id
	}
	tags = {
		Name = "${var.cluster_name}-public"
		}
}

resource "aws_route_table_association" "map_public_ip_on_launch" {
	count = length(var.public-subnet-cidrs)
	subnet_id = element(aws_subnet.public[*].id, count.index)
	route_table_id = aws_route_table.eks-public.id

}

resource "aws_nat_gateway" "nat-gateway" {
	count = length(var.availability_zones)
	subnet_id = element(aws_subnet.public[*].id, count.index)
	allocation_id = aws_eip.nat-eip[count.index].id
	tags = {
		Name = "${var.cluster_name}-nat-gateway-${count.index}"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	}

}

resource "aws_route_table" "eks-private" {
	count = length(var.private-subnet-cidrs)
	vpc_id = aws_vpc.eks-vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = element(aws_nat_gateway.nat-gateway[*].id, count.index)
	}
}

resource "aws_route_table_association" "private" {
	count = length(var.private-subnet-cidrs)
	subnet_id = element(aws_subnet.private[*].id, count.index)
	route_table_id = element(aws_route_table.eks-private[*].id, count.index)

}
