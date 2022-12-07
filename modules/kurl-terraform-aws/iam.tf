resource "aws_iam_instance_profile" "master" {
  name = "${var.name}-kurl-master-instance-profile"
  role = aws_iam_role.master.name
}

resource "aws_iam_role" "master" {
  name               = "${var.name}-kurl-master-instance-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = local.common_master_tags
}

resource "aws_iam_policy" "master_eip" {
  name        = "${var.name}-kurl-master-instance-eip-policy"
  path        = "/"
  description = "EIP Associate IAM Policy of Kurl Master Instance"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeAddresses",
          "ec2:AllocateAddress",
          "ec2:DescribeInstances",
          "ec2:AssociateAddress"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "parameter_store" {
  name        = "${var.name}-kurl-master-instance-parameter-store-policy"
  path        = "/"
  description = "Parameter Store IAM Policy of Kurl Master Instance"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["ssm:GetParametersByPath", "ssm:PutParameter"],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "master_eip" {
  policy_arn = aws_iam_policy.master_eip.arn
  role       = aws_iam_role.master.name
}

resource "aws_iam_role_policy_attachment" "master_ssm" {
  policy_arn = var.ssm_policy_arn
  role       = aws_iam_role.master.name
}

resource "aws_iam_role_policy_attachment" "master_parameter_store" {
  policy_arn = aws_iam_policy.parameter_store.arn
  role       = aws_iam_role.master.name
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.name}-kurl-node-instance-profile"
  role = aws_iam_role.node.name
}

resource "aws_iam_role" "node" {
  name               = "${var.name}-kurl-node-instance-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = local.common_node_tags
}

resource "aws_iam_policy" "node_parameter_store" {
  name        = "${var.name}-kurl-node-instance-parameter-store-policy"
  path        = "/"
  description = "Parameter Store IAM Policy of Kurl Node Instance"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["ssm:GetParametersByPath", "ssm:PutParameter"],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_ssm" {
  policy_arn = var.ssm_policy_arn
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_parameter_store" {
  policy_arn = aws_iam_policy.node_parameter_store.arn
  role       = aws_iam_role.node.name
}


