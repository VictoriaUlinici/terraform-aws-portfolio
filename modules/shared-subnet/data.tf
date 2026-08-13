data "aws_security_group" "internal" {
  count = var.internal_security_group_id != null ? 1 : 0
  id    = var.internal_security_group_id
}
