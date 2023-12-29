terraform {
  required_version = "~> 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "ccVPC" {
  source = "./modules/vpc"

  vpc_cidr             = local.vpc_cidr
  vpc_tags             = var.vpc_tags
  availability_zones   = local.availability_zones
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
}

module "elasticsearch" {
  source = "./modules/elasticsearch"

  cc_private_subnets = module.ccVPC.private_subnets
}

module "rds" {
  source = "./modules/rds"

  cc_vpc_id               = module.ccVPC.vpc_id
  cc_private_subnets      = module.ccVPC.private_subnets
  cc_private_subnet_cidrs = local.private_subnet_cidrs

  rds_az            = local.availability_zones[0]
  rds_name          = "parking"
  rds_user_name     = "root"
  rds_user_password = "password"
}

module "docdb" {
  source = "./modules/docdb"

  cc_vpc_id               = module.ccVPC.vpc_id
  cc_private_subnets      = module.ccVPC.private_subnets
  cc_private_subnet_cidrs = local.private_subnet_cidrs

  docdb_az            = local.availability_zones[0]
  docdb_name          = "parking"
  docdb_user_name     = "root"
  docdb_user_password = "password"
}

module "elasticache" {
  source = "./modules/elasticache"

  cc_vpc_id               = module.ccVPC.vpc_id
  cc_private_subnets      = module.ccVPC.private_subnets
  cc_private_subnet_cidrs = local.private_subnet_cidrs

  elasticache_name = "elasticache-instance"
}

module "webserver" {
  source = "./modules/webserver"

  webserver_az = local.availability_zones[0]

  cc_vpc_id         = module.ccVPC.vpc_id
  cc_public_subnets = module.ccVPC.public_subnets
}

resource "aws_key_pair" "ccKP" {
  key_name   = "ccKP"
  public_key = file("${path.module}/keypair/public-key.pub")
}

output "webserver1_public_ip" {
  value = module.webserver.webserver1_public_ip
}

output "webserver2_public_ip" {
  value = module.webserver.webserver2_public_ip
}

output "rds-endpoint" {
  value = module.rds.rds-endpoint
}

output "rds-username" {
  value     = module.rds.rds-username
  sensitive = true
}

output "rds-password" {
  value     = module.rds.rds-password
  sensitive = true
}

output "rds-url" {
  value = module.rds.rds-url
}

output "rds-replica-url" {
  value = module.rds.replica-url
}

output "docdb-endpoint" {
  value = module.docdb.docdb-endpoint
}
output "docdb-username" {
  value     = module.docdb.docdb-username
  sensitive = true
}
output "docdb-password" {
  value     = module.docdb.docdb-password
  sensitive = true
}
