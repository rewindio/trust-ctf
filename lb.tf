# ###======================== CTF ALB ====================== ###

resource "aws_lb" "owaspjs" {
  # checkov:skip=CKV_AWS_150: Ensure that Load Balancer has deletion protection enabled
  # checkov:skip=CKV_AWS_91: Ensure the ELBv2 (Application/Network) has access logging enabled
  # checkov:skip=CKV_AWS_131: Ensure that ALB drops HTTP headers

  load_balancer_type         = "application"
  enable_deletion_protection = false
  enable_http2               = true
  ip_address_type            = "ipv4"
  drop_invalid_header_fields = false
  internal                   = false
  name                       = "owaspjs-alb"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

resource "aws_lb_target_group" "owaspjs" {
  name     = "owasp-js-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ctf.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    matcher             = "200,403"
  }
}

resource "aws_lb_target_group_attachment" "owaspjs" {
  target_group_arn = aws_lb_target_group.owaspjs.arn
  target_id        = aws_instance.owaspjs.id
  port             = 80
}

resource "aws_lb_listener" "owaspjs" {
  # checkov:skip=CKV_AWS_2: Ensure ALB protocol is HTTPS

  load_balancer_arn = aws_lb.owaspjs.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.owaspjs.arn
  }
}

resource "aws_lb" "cftd" {
  # checkov:skip=CKV_AWS_150: Ensure that Load Balancer has deletion protection enabled
  # checkov:skip=CKV_AWS_91: Ensure the ELBv2 (Application/Network) has access logging enabled
  # checkov:skip=CKV_AWS_131: Ensure that ALB drops HTTP headers

  load_balancer_type         = "application"
  enable_deletion_protection = false
  enable_http2               = true
  ip_address_type            = "ipv4"
  drop_invalid_header_fields = false
  internal                   = false
  name                       = "cftd-alb"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

resource "aws_lb_target_group" "cftd" {
  name     = "cftd-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ctf.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    matcher             = "200,403"
  }
}

resource "aws_lb_target_group_attachment" "cftd" {
  target_group_arn = aws_lb_target_group.cftd.arn
  target_id        = aws_instance.ctfd.id
  port             = 80
}

resource "aws_lb_listener" "cftd" {
  # checkov:skip=CKV_AWS_2: Ensure ALB protocol is HTTPS

  load_balancer_arn = aws_lb.cftd.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cftd.arn
  }
}
