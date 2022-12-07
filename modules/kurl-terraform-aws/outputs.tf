output "kubeconfig" {
  value     = data.aws_ssm_parameter.kubeconfig.value
  sensitive = true
}

output "kurlconfig" {
  value = var.kurl_config
}
