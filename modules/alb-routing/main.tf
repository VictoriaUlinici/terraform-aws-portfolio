resource "aws_lb_target_group" "this" {
  for_each = var.services

  name        = each.key
  port        = each.value.target_group_port
  protocol    = each.value.target_group_protocol
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = each.value.health_check_path
    protocol            = each.value.target_group_protocol
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  lifecycle {
    ignore_changes = [health_check]
  }
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = {
    for pair in flatten([
      for svc_key, svc in var.services : [
        for ip in svc.target_ips : {
          key = "${svc_key}-${ip}"
          svc = svc_key
          ip  = ip
        }
      ]
    ]) : pair.key => pair
  }

  target_group_arn = aws_lb_target_group.this[each.value.svc].arn
  target_id        = each.value.ip
  port             = var.services[each.value.svc].target_group_port
}

resource "aws_lb_listener_certificate" "this" {
  for_each = { for k, v in var.services : k => v if v.certificate_arn != null }

  listener_arn    = var.listener_arns[tostring(each.value.listener_port)]
  certificate_arn = each.value.certificate_arn
}

resource "aws_lb_listener_rule" "this" {
  for_each = var.services

  listener_arn = var.listener_arns[tostring(each.value.listener_port)]
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }

  condition {
    host_header {
      values = [each.value.host_header]
    }
  }

  dynamic "condition" {
    for_each = each.value.path_pattern != null ? [each.value.path_pattern] : []
    content {
      path_pattern {
        values = [condition.value]
      }
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}
