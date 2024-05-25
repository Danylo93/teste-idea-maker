provider "aws" {
  region = "us-east-1" 
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "allow_http" {
  vpc_id = aws_vpc.main.id

  // Permitir tráfego HTTP (porta 80) e SSH (porta 22)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Permitir todo o tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0e001c9271cf7f3b9"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  key_name      = "teste-devops"

  // Associar o grupo de segurança diretamente usando o ID do grupo de segurança
  security_groups = [aws_security_group.allow_http.id]

  // Garantir que a instância tenha um endereço IP público
  associate_public_ip_address = true

  tags = {
    Name = "Servidor Web Nginx"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<html><body><h1>Olá, Mundo!</h1></body></html>" > /var/www/html/index.html
              EOF
}


# Chamada para o script de implantação usando local-exec
resource "null_resource" "deploy" {
  provisioner "local-exec" {
    command = "./deploy.sh"
  }

  depends_on = [aws_instance.web]
}
