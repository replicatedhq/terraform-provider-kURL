# EIP
resource "aws_eip" "master" {
  tags = {
    Name = "${var.name}-kurl-master-eip"
  }

  lifecycle {
    prevent_destroy = false
  }
}
