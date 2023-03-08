# security group for application load balancer, to allow acess from any where for HTTP and HTTPS traffic
resource "aws_security_group" "ext_alb_sg" {
  name        = "ext_alb_sg"
  vpc_id      = aws_vpc.myiacvpc.id
  description = "Allow TLS inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "external-apploadbalancer-sg"
  }

}

# security group for bastion, to allow access into the bastion host from your IP
resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  vpc_id      = aws_vpc.myiacvpc.id
  description = "Allow incoming ssh connections."

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion-SG"
  }
}

#security group for nginx reverse proxy, to allow access only from the external load balancer and bastion instance
resource "aws_security_group" "nginx-sg" {
  name   = "nginx-sg"
  vpc_id = aws_vpc.myiacvpc.id
  ingress {
    description = "inbound-nginx-https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

    security_groups = [aws_security_group.ext_alb_sg.id]
  }
  ingress {
    description = "inbound-bastion-ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    security_groups = [aws_security_group.bastion_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-SG"
  }

}

#   resource "aws_security_group_rule" "inbound-nginx-http" {
#   type                     = "ingress"
#   from_port                = 443
#   to_port                  = 443
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.ext_alb_sg.id
#   security_group_id        = aws_security_group.nginx-sg.id
# }

# resource "aws_security_group_rule" "inbound-bastion-ssh" {
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.bastion_sg.id
#   security_group_id        = aws_security_group.nginx-sg.id
# }

# security group for internal application load balancer, to allow acess from any where for HTTP and HTTPS traffic
resource "aws_security_group" "int_alb_sg" {
  name        = "int_alb_sg"
  vpc_id      = aws_vpc.myiacvpc.id
  description = "Allow TLS inbound traffic"

  ingress {
    description     = "Allow acces only from nginx reverser proxy server"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "internal-apploadbalancer-sg"
  }

}

# security group for webservers, to have access only from the internal load balancer and bastion instance
resource "aws_security_group" "webserver-sg" {
  name   = "webserver-sg"
  vpc_id = aws_vpc.myiacvpc.id

  ingress {
    description     = "Allow acces from internal load balancer"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.int_alb_sg.id]
  }
  ingress {
    description     = "Allow acces from internal ssh bastion instance"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver-sg"
  }

}
# security group for datalayer to alow traffic from websever on nfs and mysql port and bastion host on mysql port
resource "aws_security_group" "datalayer-sg" {
  name   = "datalayer-sg"
  vpc_id = aws_vpc.myiacvpc.id

  ingress {
    description     = "Allow traffic from mysql webserver"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver-sg.id]
  }
  ingress {
    description     = "Allow traffic from mysql bastion"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "datalayer-sg"
  }
}


