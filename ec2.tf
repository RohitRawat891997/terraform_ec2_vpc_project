resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "main" {
  public_key  = file("ec2-key.pub")
  key_name = "ec2-key"
}

resource "aws_instance" "main" {
  instance_type = "t2.micro"
  ami = data.aws_ami.ubuntu.id
  subnet_id = values(aws_subnet.main)[5].id
  vpc_security_group_ids = [aws_security_group.main.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.main.key_name

  tags = {
    Name = "dev-instance"
  }
}

output "subnet_list" {
  value = aws_instance.main.public_ip
  description = "public ip of aws instance"
}