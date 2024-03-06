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

resource "aws_key_pair" "project_key" {
    key_name = "project-key"
    public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "lab_Jenkins" {
         ami = var.ami[0]
         instance_type = var.instance_type[2]
         key_name = aws_key_pair.project_key.id
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

#resource "aws_instance" "lab_ansible_manger" {
         ami = var.ami[1]
         instance_type = var.instance_type[0]
         key_name = aws_key_pair.project_key.id
         subnet_id = aws_subnet.lab_subnet.id
         vpc_security_group_ids = [aws_security_group.lab_sg.id]
         user_data = file("userdata_ansible.tpl")
         tags = {
          Name = "lab-ansible-manger"
         }
         provisioner "file" {
          source      = "/home/venkat/DEVOPS/Project-2/Ansible"
          destination = "/tmp"
        }
         connection {
          type        = "ssh"
          user        = "ec2-user"             # Replace with your SSH user
          private_key = file("~/.ssh/id_ed25519")  # Replace with your private key path
          host  = self.public_ip
        }
}        
#resource "aws_instance" "lab_ansible_node1" {
         ami = var.ami[1]
         instance_type = var.instance_type[0]
         key_name = aws_key_pair.project_key.id
         subnet_id = aws_subnet.lab_subnet.id
         vpc_security_group_ids = [aws_security_group.lab_sg.id]
         user_data = file("userdata_ansmanged.tpl")
         tags = {
          Name = "tomcat"
         }
}
#resource "aws_instance" "lab_ansible_node2" {
         ami = var.ami[0]
         instance_type = var.instance_type[0]
         key_name = aws_key_pair.project_key.id
         subnet_id = aws_subnet.lab_subnet.id
         vpc_security_group_ids = [aws_security_group.lab_sg.id]
         user_data = file("userdata_docker.tpl")
         tags = {
          Name = "docker"
         }
}

#terraform import aws_key_pair.project_key project-key#
