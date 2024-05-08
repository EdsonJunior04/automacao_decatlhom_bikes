provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["./aws/config"]
  shared_credentials_files = ["./aws/config"]
}

resource "aws_instance" "ec2_instance_linux1" {
  ami                    = "ami-07caf09b362be10b8"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-068bc90d5349e8efa" # ID da Subnet
  vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]

  key_name = "MinhaChaveEdson"

  user_data = <<-EOF
              #!/bin/bash
              yum -y update
              yum install -y httpd git efs-utils
              sudo systemctl enable httpd
              sudo systemctl start httpd
              cd /var/www/html/
              rm index.html
              cd /home/ec2-user/
              git clone https://github.com/FofuxoSibov/sitebike.git
              cd sitebike
              mv ./* /var/www/html/

              sudo mkdir efs
              sudo mount -t efs ${aws_efs_file_system.decatlhombikescompa.id} efs/

              EOF

  tags = {
    Name = "EC2_Instance-alpine-0"
  }


}
resource "aws_instance" "ec2_instance_linux2" {
  ami                    = "ami-07caf09b362be10b8"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-068bc90d5349e8efa" # ID da Subnet
  vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]


  key_name = "MinhaChaveEdson"

  user_data = <<-EOF
              #!/bin/bash
              yum -y update
              yum install -y httpd git efs-utils
              sudo systemctl enable httpd
              sudo systemctl start httpd
              cd /var/www/html/
              rm index.html
              cd /home/ec2-user/
              git clone https://github.com/FofuxoSibov/sitebike.git
              cd sitebike
              mv ./* /var/www/html/

              sudo mkdir efs
              sudo mount -t efs ${aws_efs_file_system.decatlhombikescompa.id} efs/
              EOF

  tags = {
    Name = "EC2_Instance-alpine-1"
  }



}


resource "aws_security_group" "instance_sg" {
  name        = "instance_sg-5"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = "vpc-031e71479d4c06df6"

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

resource "aws_efs_file_system" "decatlhombikescompa" {
  creation_token = "decatlhombikescompa"


  tags = {
    Name = "decatlhombikescompa"
  }
}

output "public_ip_1" {
  value = aws_instance.ec2_instance_linux1.public_ip
}

output "public_ip_2" {
  value = aws_instance.ec2_instance_linux2.public_ip
}

output "name" {
  value = aws_efs_file_system.decatlhombikescompa.id
}

