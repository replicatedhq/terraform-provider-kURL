data "template_file" "master_user_data" {
  template = file("${path.module}/master-init.tpl")
  vars = {
    aws_eip     = "${aws_eip.master.id}"
    aws_region  = "${var.aws_region}"
    name        = "${var.name}"
    kurl_config = "${var.kurl_config}"
  }
}

data "template_file" "node_user_data" {
  count    = local.enable_node ? 1 : 0
  template = file("${path.module}/node-init.tpl")
  vars = {
    node_join_cmd = "${data.aws_ssm_parameter.join_node[0].value}"
    aws_region    = "${var.aws_region}"
    name          = "${var.name}"
  }
}
