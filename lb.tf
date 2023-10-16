# ###======================== CTF ALB ====================== ###

resource "aws_lb" "owaspjs" {
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
  load_balancer_arn = aws_lb.owaspjs.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.owaspjs.arn
  }
}

resource "aws_lb" "cftd" {
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
  load_balancer_arn = aws_lb.cftd.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cftd.arn
  }
}
