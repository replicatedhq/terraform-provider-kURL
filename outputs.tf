output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  value = { for k, v in module.vpc.public_subnets : k => v.id }
}

output "public_subnet_cidr_blocks" {
  value = { for k, v in module.vpc.public_subnets : k => v.cidr_block }
}

output "public_route_table_ids" {
  value = { for k, v in module.vpc.public_route_tables : k => v.id }
}

output "kubeconfig" {
  value     = module.kurl.kubeconfig
  sensitive = true
}

output "kurlconfig" {
  value = module.kurl.kurlconfig
}
