resource "aws_lb" "this" {
  name               = "guipedroso-ecs-portal-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnet_1a_id, var.public_subnet_1b_id]
}

resource "aws_lb_target_group" "this" {
  name        = "guipedroso-ecs-tg-v2"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener_certificate" "this" {
  listener_arn    = aws_lb_listener.this.arn
  certificate_arn = var.certificate_arn
}
