module "reverse_proxy" {
  source = "../modules/alb-routing"

  vpc_id        = var.vpc_id
  listener_arns = var.listener_arns
  services      = var.services
}

module "shared_subnets" {
  source = "../modules/shared-subnet"

  vpc_id                     = var.vpc_id
  internal_security_group_id = var.internal_security_group_id
  subnets                    = var.shared_subnets
}
