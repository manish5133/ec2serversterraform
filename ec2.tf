# SSH Key
resource "aws_key_pair" "openstack-key" {
    key_name = "openstack-key"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
}


#Create EC2 VM Controller.tf
resource "aws_network_interface" "Controller" {
  subnet_id = "${aws_subnet.openstack-subnet-public.id}"
  private_ips = ["10.194.100.11"]
  availability_zone = "${var.AZ}"  
  security_groups = ["${aws_security_group.ssh-allowed.id}"]
  tags = {
    Name = "primary_network_interface_controller"
  }
}

resource "aws_instance" "Controller" {
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    root_block_device {
     volume_size = 60
     volume_type = "gp2"
     delete_on_termination = true
    }
    availability_zone = "${var.AZ}"
    instance_type = "${var.INSTANCE_TYPE}"
    key_name = "${aws_key_pair.openstack-key.id}"
    network_interface {
     network_interface_id = "${aws_network_interface.Controller.id}"
     device_index = 0
    }
    tags = {
        Name: "Controller"
    }
}


#Create EC2 VM Storage.tf
resource "aws_network_interface" "Storage" {
  subnet_id = "${aws_subnet.openstack-subnet-public.id}"
  private_ips = ["10.194.100.12"]  
  availability_zone = "${var.AZ}"
  security_groups = ["${aws_security_group.ssh-allowed.id}"]
  tags = {
    Name = "primary_network_interface_storage"
  }
}

resource "aws_instance" "Storage" {
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    root_block_device {
     volume_size = 60
     volume_type = "gp2"
     delete_on_termination = true
    }
    availability_zone = "${var.AZ}"
    instance_type = "${var.INSTANCE_TYPE}"
    key_name = "${aws_key_pair.openstack-key.id}"
    network_interface {
     network_interface_id = "${aws_network_interface.Storage.id}"
     device_index = 0
    }
    tags = {
        Name: "Storage"
    }
}
resource "aws_ebs_volume" "storage_sdb" {
  size              = 100
  availability_zone = "${var.AZ}"  
}

resource "aws_volume_attachment" "storage_sdb" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.storage_sdb.id
  instance_id = aws_instance.Storage.id
}

#Create EC2 VM Compute.tf
resource "aws_network_interface" "Compute" {
  subnet_id = "${aws_subnet.openstack-subnet-public.id}"
  private_ips = ["10.194.100.13"]
  availability_zone = "${var.AZ}"  
  security_groups = ["${aws_security_group.ssh-allowed.id}"]
  tags =  {
    Name = "primary_network_interface_compute"
  }
}

resource "aws_instance" "Compute" {
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    root_block_device {
     volume_size = 60
     volume_type = "gp2"
     delete_on_termination = true
    }
    availability_zone = "${var.AZ}"
    instance_type = "${var.INSTANCE_TYPE}"
    key_name = "${aws_key_pair.openstack-key.id}"
    network_interface {
     network_interface_id = "${aws_network_interface.Compute.id}"
     device_index = 0
    }
    tags = {
        Name: "Compute"
    }
}
