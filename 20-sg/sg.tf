module "mysql_sg" {
  source       = "git::https://github.com/sujithyerra4/terraform-aws-sg.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = local.vpc_id
  sg_name      = "mysql"
  common_tags  = var.common_tags
  sg_tags      = var.mysql_sg_tags
}

module "backend_sg" {
  source       = "git::https://github.com/sujithyerra4/terraform-aws-sg.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = local.vpc_id
  sg_name      = "backend"
  common_tags  = var.common_tags
  sg_tags      = var.backend_sg_tags
}

module "frontend_sg" {
  source       = "git::https://github.com/sujithyerra4/terraform-aws-sg.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = local.vpc_id
  sg_name      = "frontend"
  common_tags  = var.common_tags
  sg_tags      = var.frontend_sg_tags
}

#  from this we can connect to frontend,backend,db
module "bastion_sg" {
  source       = "git::https://github.com/sujithyerra4/terraform-aws-sg.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = local.vpc_id
  sg_name      = "bastion"
  common_tags  = var.common_tags
  sg_tags      = var.bastion_sg_tags
}

module "ansible_sg" {
  source       = "git::https://github.com/sujithyerra4/terraform-aws-sg.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = local.vpc_id
  sg_name      = "ansible"
  common_tags  = var.common_tags
  sg_tags      = var.anisble_sg_tags
}

# MySQL allowing connection on 3306 from the instances attached to Backend SG
resource "aws_security_group_rule" "mysql_backend" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend_sg.id //allowing connection
  security_group_id        = module.mysql_sg.id   //in which sg group you r entering rule
}

resource "aws_security_group_rule" "backend_frontend" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.frontend_sg.id
  security_group_id        = module.backend_sg.id
}

resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend_sg.id
}




# mysql accepting connections from bastion
resource "aws_security_group_rule" "mysql_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id        = module.mysql_sg.id
}

resource "aws_security_group_rule" "backend_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id        = module.backend_sg.id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id        = module.frontend_sg.id
}

resource "aws_security_group_rule" "mysql_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id        = module.mysql_sg.id
}

resource "aws_security_group_rule" "backend_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id        = module.backend_sg.id
}

resource "aws_security_group_rule" "frontend_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id        = module.frontend_sg.id
}

resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ansible_sg.id
}

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.id
}
