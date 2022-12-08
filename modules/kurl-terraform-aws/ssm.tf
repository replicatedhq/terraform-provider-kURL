resource "time_sleep" "wait_600_seconds" {
  count      = local.enable_node ? 1 : 0
  depends_on = [aws_launch_template.master]

  create_duration = "600s"
}

data "aws_ssm_parameter" "join_node" {
  count      = local.enable_node ? 1 : 0
  name       = "${var.name}-kurl-node-join"
  depends_on = [time_sleep.wait_600_seconds[0]]
}

data "aws_ssm_parameter" "kubeconfig" {
  name = "${var.name}-kurl-kubeconfig"
}
