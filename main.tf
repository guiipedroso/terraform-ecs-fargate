module "network" {
  source = "./modules/network"
}

module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id
}

module "acm" {
  source = "./modules/acm"

  domain = var.domain
}

resource "aws_route53_record" "apex" {
  zone_id = module.acm.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = module.acm.zone_id
  name    = "www.${var.domain}"
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}

module "alb" {
  source = "./modules/alb"

  vpc_id              = module.network.vpc_id
  public_subnet_1a_id = module.network.public_subnet_1a_id
  public_subnet_1b_id = module.network.public_subnet_1b_id
  alb_sg_id           = module.security.alb_sg_id
  certificate_arn     = module.acm.certificate_arn
}

module "ecs" {
  source = "./modules/ecs"

  private_subnet_1a_id = module.network.private_subnet_1a_id
  private_subnet_1b_id = module.network.private_subnet_1b_id
  ecs_sg_id            = module.security.ecs_sg_id
  execution_role_arn   = module.security.ecs_execution_role_arn
  target_group_arn     = module.alb.target_group_arn
}
