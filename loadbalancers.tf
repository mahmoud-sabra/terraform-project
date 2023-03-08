# # External loadbalancer
# resource "aws_lb" "ext-alb" {
#   name               = "ext-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.ext_alb_sg.id]
#   subnets            = [for subnet in aws_subnet.public : subnet.id]

#   enable_deletion_protection = true

# #   access_logs {
# #     bucket  = aws_s3_bucket.lb_logs.bucket
# #     prefix  = "test-lb"
# #     enabled = true
# #   }

#   tags = {
#     Environment = "production"
#   }
# }


resource "aws_lb" "ext-alb" {
  name            = "ext-alb"
  internal        = false
  security_groups = [aws_security_group.ext_alb_sg.id]

  subnets = [for subnet in aws_subnet.public : subnet.id]

  tags = {
    Name = "external-alb"
  }

  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
}

# --- create a target group for the external load balancer

resource "aws_lb_target_group" "nginx-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = "nginx-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance" #default
  vpc_id      = aws_vpc.myiacvpc.id
}

# --- create listener for load balancer

resource "aws_lb_listener" "nginx-listner" {
  load_balancer_arn = aws_lb.ext-alb.arn
  port              = 443
  protocol          = "HTTP"
  # certificate_arn   = aws_acm_certificate_validation.bulwm.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-tgt.arn
  }
}

# ---Internal Load Balancers for webservers----

resource "aws_lb" "int-alb" {
  name            = "int-alb"
  internal        = true
  security_groups = [aws_security_group.int_alb_sg.id]

  subnets = [for subnet in aws_subnet.private : subnet.id if subnet.cidr_block == "10.0.3.0/24" || subnet.cidr_block == "10.0.4.0/24"]

  tags = {
    Name = "int-alb"
  }
  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
}

# --- target group  for websever -------

resource "aws_lb_target_group" "webserver-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "webserver-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = aws_vpc.myiacvpc.id
}




# For this aspect a single listener was created for the wordpress which is default,
# A rule was created to route traffic to tooling when the host header changes

resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.int-alb.arn
  port              = 443
  protocol          = "HTTP"
  # certificate_arn   = aws_acm_certificate_validation.bulwm.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver-tgt.arn
  }
}



