resource "aws_vpc" "lab" {
  cidr_block = "20.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Mylab"
  }
}
resource "aws_subnet" "lab_subnet" {
    cidr_block = "20.0.1.0/24"
    vpc_id = aws_vpc.lab.id
    map_public_ip_on_launch = true
    tags = {
      Name = "Mylab-subnet"
    }
}
resource "aws_internet_gateway" "lab_gw" {
     vpc_id = aws_vpc.lab.id
     tags = {
      Name = "Mylab-gw"
     }
}
resource "aws_route_table" "lab_rt" {
     vpc_id = aws_vpc.lab.id
     tags = {
      Name = "Mylab-routingtable"
     }
}
resource "aws_route" "lab_default_route" {
           route_table_id = aws_route_table.lab_rt.id
           destination_cidr_block = "0.0.0.0/0"
           gateway_id = aws_internet_gateway.lab_gw.id
}

resource "aws_route_table_association" "lab_route_associate" {
          subnet_id = aws_subnet.lab_subnet.id
          route_table_id = aws_route_table.lab_rt.id
}
resource "aws_security_group" "lab_sg" {
          name = "lab-sg"
          vpc_id = aws_vpc.lab.id

         dynamic ingress {
            iterator = port
            for_each = var.port
            content {
             from_port = port.value
             to_port = port.value
             protocol = "tcp"
             cidr_blocks = ["0.0.0.0/0"]
            }
          }
          egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }
}

resource "aws_instance" "lab_Jenkins" {
         ami = var.ami[0]
         instance_type = var.instance_type[1]
         key_name = "lappy"
         subnet_id = aws_subnet.lab_subnet.id
         vpc_security_group_ids = [aws_security_group.lab_sg.id]
         root_block_device {
            volume_size = 15
         }
         user_data = file("userdata_jenkins.tpl")
         tags = {
          Name = "lab-jenkins"
         }
}
