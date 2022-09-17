#esto es un comentario
provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = "us-west-1"
}
resource "aws_instance" "Reverse-Proxy" {
  instance_type          = var.AWS_INSTANCE_TYPE
  ami                    = var.AWS_AMI
  key_name               = var.AWS_KEY_NAME
  user_data              = filebase64("${path.module}/script/docker.sh")
  vpc_security_group_ids = [aws_security_group.WebSG.id]
  tags = {
    Name = "Servidor"
  }
}
resource "aws_security_group" "WebSG" {
  name = "sg_reglas_firewall"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SG HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SG HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SG SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SG ALL Trafic All Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }
}
output "public_ip" {

  value = "${join(",", aws_instance.Reverse-Proxy.*.public_ip)}"

}