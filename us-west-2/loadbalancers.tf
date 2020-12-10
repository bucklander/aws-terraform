## App LB Example

resource "aws_lb" "alb-int-example" {
  load_balancer_type = "application"
  name               = "alb-int-example"
  internal           = true
  security_groups    = [aws_security_group.allow_http.id, aws_security_group.allow_tls.id]
  subnet_mapping {
    subnet_id = aws_subnet.subnet-b.id
    #private_ipv4_address = "10.12.2.30" # contrary to TF docs, this doesn't seem allowed by the provider
  }
  subnet_mapping {
    subnet_id = aws_subnet.subnet-c.id
    #private_ipv4_address = "10.12.3.30" # contrary to TF docs, this doesn't seem allowed by the provider
  }
  enable_deletion_protection = false

  tags = {
    Environment = "development"
  }
}

resource "aws_lb_target_group" "alb-tg-int-example" {
  name                          = "alb-tg-int-example"
  vpc_id                        = aws_vpc.main-vpc.id
  port                          = 80
  protocol                      = "HTTP"
  target_type                   = "instance"
  load_balancing_algorithm_type = "round_robin"
  stickiness {
    type    = "lb_cookie"
    enabled = true
  }
  health_check {
    enabled             = true
    interval            = "30"
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = "3"
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    matcher             = "200,202"
  }
}

resource "aws_lb_listener" "alb-lis-int-example" {
  load_balancer_arn = aws_lb.alb-int-example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "alb-lis-int-example-rule1" {
  listener_arn = aws_lb_listener.alb-lis-int-example.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg-int-example.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_lb_target_group_attachment" "alb-attach-int-example" {
  target_group_arn = aws_lb_target_group.alb-tg-int-example.arn
  target_id        = aws_instance.foo.id
  port             = 80
}