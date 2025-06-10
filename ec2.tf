#Key pair (login)
#generate key by - ssh-keygen - 2 files cretes 1 is pvt key, 2d is public key
# can write pub in code , so use arguments

resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2-dev"
  public_key = file("terra-key-ec2.pub")
}

#vpc and SG
resource "aws_default_vpc" "default_vpc" {

}

#aws SG group
resource "aws_security_group" "my_security_group" {
  name        = "auto-sg-dev"
  description = "i am creating TF generated SG"
  vpc_id      = aws_default_vpc.default_vpc.id //interpolation - inherite values from main source

  tags = {
    name = "my-sg"
  }
  #inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH configured"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP configured"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "app port"
  }

  #outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" //open to all ports
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"
  }

}


#EC2 instance

resource "aws_instance" "linux-server" {
  #count = 2
  for_each = tomap({
    "linux-1-t2micro" = "t2.micro"
    #"linux-2-medium"  = "t2.medium"
  })
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  instance_type   = each.value
  ami             = "ami-0953476d60561c955" //ubuntu

  #depends on
  depends_on = [aws_security_group.my_security_group]

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  user_data = file("script.sh")

  tags = {
    name = each.key
    environment = var.env
  }

}


