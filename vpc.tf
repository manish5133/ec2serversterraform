#Create vpc.tf

resource "aws_vpc" "openstack-vpc" {
    cidr_block = "10.194.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags = {
        Name = "openstack-vpc"
    }
}

resource "aws_subnet" "openstack-subnet-public" {
    vpc_id = "${aws_vpc.openstack-vpc.id}"
    cidr_block = "10.194.100.0/24"
    map_public_ip_on_launch = "true" 
    availability_zone = "${var.AWS_REGION}"
    tags = {
        Name = "openstack-subnet-public"
    }
}

# Add internet gateway
resource "aws_internet_gateway" "openstack-igw" {
    vpc_id = "${aws_vpc.openstack-vpc.id}"
    tags = {
        Name = "openstack-igw"
    }
}

# Public routes
resource "aws_route_table" "openstack-public-crt" {
    vpc_id = "${aws_vpc.openstack-vpc.id}"
    
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.openstack-igw.id}" 
    }
    
    tags = {
        Name = "openstack-public-crt"
    }
}

resource "aws_route_table_association" "openstack-crta-public-subnet"{
    subnet_id = "${aws_subnet.openstack-subnet-public.id}"
    route_table_id = "${aws_route_table.openstack-public-crt.id}"
}