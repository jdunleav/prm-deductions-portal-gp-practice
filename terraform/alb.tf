resource "aws_alb_target_group" "alb-tg" {
  name                  = "${var.environment}-${var.component_name}-alb-tg"
  port                  = 3000
  protocol              = "HTTP"
  vpc_id                = data.aws_ssm_parameter.deductions_public_vpc_id.value
  target_type           = "ip"
  deregistration_delay  = 20
}

resource "aws_alb_listener" "alb-listener-http" {
  load_balancer_arn = data.aws_ssm_parameter.deductions_public_alb_arn.value
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "alb-listener-https" {
  load_balancer_arn = data.aws_ssm_parameter.deductions_public_alb_arn.value
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate_validation.default.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.alb-tg.arn
    type             = "forward"
  }
}
