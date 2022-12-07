resource "time_sleep" "wait_600_seconds" {
  depends_on = [aws_launch_template.master]

  create_duration = "600s"
}


data "aws_ssm_parameter" "join_node" {
  name       = "${var.name}-kurl-node-join"
  depends_on = [time_sleep.wait_600_seconds]
}

data "aws_ssm_parameter" "kubeconfig" {
  name       = "${var.name}-kurl-kubeconfig"
  depends_on = [time_sleep.wait_600_seconds]
}
