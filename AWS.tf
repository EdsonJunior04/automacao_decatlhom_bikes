provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["./aws/config"]
  shared_credentials_files = ["./aws/config"]
}

resource "aws_efs_file_system" "decatlhombikescompa" {
  creation_token = "decatlhombikescompa"

  tags = {
    Name = "decatlhombikescompa"
  }
}

resource "aws_efs_mount_target" "decathlombikemount" {
  file_system_id = aws_efs_file_system.decatlhombikescompa.id
  subnet_id      = "subnet-0edbc11ff905813c6"
  security_groups = [ aws_security_group.instance_sg.id ]
}

resource "aws_instance" "ec2_instance_linux1" {
  ami                    = "ami-07caf09b362be10b8"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0edbc11ff905813c6" # ID da Subnet
  vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]

  key_name = "MinhaChaveEdson"

  user_data = <<-EOF
              #!/bin/bash
              yum -y update
              yum install -y httpd git amazon-efs-utils
              sudo systemctl enable httpd
              sudo systemctl start httpd
              cd /var/www/html/
              rm index.html
              cd /home/ec2-user/
              git clone https://github.com/FofuxoSibov/sitebike.git
              cd sitebike
              mv ./* /var/www/html/
              cd /home/ec2-user/
              sudo mkdir efs
              sudo chmod 777 efs/
              sudo yum update && sudo yum install python3-pip
              sudo pip3 install botocore --upgrade
              sudo mount -t efs ${aws_efs_file_system.decatlhombikescompa.id} efs/
              EOF

  tags = {
    Name = "EC2_Instance-alpine-0"
  }


}
resource "aws_instance" "ec2_instance_linux2" {
  ami                    = "ami-07caf09b362be10b8"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0edbc11ff905813c6" # ID da Subnet
  vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]


  key_name = "MinhaChaveEdson"

  user_data = <<-EOF
              #!/bin/bash
              yum -y update
              yum install -y httpd git amazon-efs-utils
              sudo systemctl enable httpd
              sudo systemctl start httpd
              cd /var/www/html/
              rm index.html
              cd /home/ec2-user/
              git clone https://github.com/FofuxoSibov/sitebike.git
              cd sitebike
              mv ./* /var/www/html/
              cd /home/ec2-user/
              sudo mkdir efs
              sudo chmod 777 efs/
              sudo yum update && sudo yum install python3-pip
              sudo pip3 install botocore --upgrade
              sudo mount -t efs ${aws_efs_file_system.decatlhombikescompa.id} efs/
              EOF

  tags = {
    Name = "EC2_Instance-alpine-1"
  }



}


resource "aws_security_group" "instance_sg" {
  name        = "instance_sg-5"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = "vpc-0b8c2a1daea12cce1"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip_1" {
  description = "IP PUBLIC Maquina 1"
  value       = aws_instance.ec2_instance_linux1.public_ip
}

output "public_ip_2" {
  description = "IP PUBLIC Maquina 2"
  value       = aws_instance.ec2_instance_linux2.public_ip
}

output "name" {
  description = "Id do EFS"
  value       = aws_efs_file_system.decatlhombikescompa.id
}
