resource "aws_security_group" "master" {
  name        = "${var.name}-kurl-master-instance-sg"
  vpc_id      = var.vpc_id
  description = "Security group for Kurl master instance ${var.name}"
  tags        = local.common_master_tags
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.master.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
}

resource "aws_security_group_rule" "ingress_master" {
  security_group_id = aws_security_group.master.id
  type              = "ingress"
  cidr_blocks       = var.ingress_cidr_blocks
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

resource "aws_security_group_rule" "ingress_master_allow_ssh" {
  security_group_id = aws_security_group.master.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "ingress_master_allow_kubeapi" {
  security_group_id = aws_security_group.master.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
}

resource "aws_security_group_rule" "ingress_master_allow_ekco" {
  security_group_id = aws_security_group.master.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 6444
  to_port           = 6444
  protocol          = "tcp"
}

resource "aws_security_group_rule" "ingress_master_allow_http" {
  security_group_id = aws_security_group.master.id
  type              = "ingress"
  cidr_blocks       = var.ingress_cidr_blocks
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

resource "aws_security_group_rule" "ingress_master_allow_https" {
  security_group_id = aws_security_group.master.id
  type              = "ingress"
  cidr_blocks       = var.ingress_cidr_blocks
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}

resource "aws_security_group_rule" "ingress_master_allow_node" {
  security_group_id        = aws_security_group.master.id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.node.id
}

resource "aws_security_group" "node" {
  name        = "${var.name}-kurl-node-instance-sg"
  vpc_id      = var.vpc_id
  description = "Security group for Kurl Node instance ${var.name}"
  tags        = local.common_node_tags
}

resource "aws_security_group_rule" "node_egress" {
  security_group_id = aws_security_group.node.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
}

resource "aws_security_group_rule" "ingress_node" {
  security_group_id = aws_security_group.node.id
  type              = "ingress"
  cidr_blocks       = var.ingress_cidr_blocks
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

resource "aws_security_group_rule" "ingress_node_allow_ssh" {
  security_group_id = aws_security_group.node.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "ingress_node_allow_http" {
  security_group_id = aws_security_group.node.id
  type              = "ingress"
  cidr_blocks       = var.ingress_cidr_blocks
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

resource "aws_security_group_rule" "ingress_node_allow_https" {
  security_group_id = aws_security_group.node.id
  type              = "ingress"
  cidr_blocks       = var.ingress_cidr_blocks
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}

resource "aws_security_group_rule" "ingress_node_allow_master" {
  security_group_id        = aws_security_group.node.id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.master.id
}
