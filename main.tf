module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block        = var.vpc_cidr_block
  name_prefix           = "${var.env}-kurl"
  public_cidr_block_map = var.public_cidr_block_map
}

module "kurl" {
  source = "./modules/kurl-terraform-aws"

  name       = var.cluster_name
  aws_region = var.aws_region

  master_subnets = [for k, v in module.vpc.public_subnets : v.id]
  node_subnets   = [for k, v in module.vpc.public_subnets : v.id]
  vpc_id         = module.vpc.vpc_id
  image_id       = var.image_id
  kurl_config    = fileexists(var.kurl_config_path) ? file(var.kurl_config_path) : ""

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

}
