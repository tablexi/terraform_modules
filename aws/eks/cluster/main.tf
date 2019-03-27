data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "master" {
  source = "../master"

  name = "${var.name}"
  tags = "${var.tags}"
}

module "nodes" {
  source = "../nodes"

  ami                      = "${var.ami}"
  capacity_desired         = "${var.capacity_desired}"
  capacity_max             = "${var.capacity_max}"
  capacity_min             = "${var.capacity_min}"
  depends_on               = ["${module.master.endpoint}"]
  instance_type            = "${var.instance_type}"
  key_name                 = "${var.key_name}"
  master_security_group_id = "${module.master.master_security_group_id}"
  name                     = "${var.name}"
  subnets                  = "${module.master.subnets}"
  tags                     = "${var.tags}"
  vpc_id                   = "${module.master.vpc_id}"
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "${var.name}"
  tags = "${var.tags}"
}

resource "aws_iam_policy" "cluster-logging" {
  name = "${var.name}-logging"

  policy = <<-POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "logs:DescribeLogGroups"
          ],
          "Resource": [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group::log-stream:*"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "logs:DescribeLogStreams"
          ],
          "Resource": [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.logs.name}:log-stream:*"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource": [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.logs.name}:log-stream:fluentd-cloudwatch"
          ]
        }
      ]
    }
    POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-logging" {
  policy_arn = "${aws_iam_policy.cluster-logging.arn}"
  role       = "${replace(module.nodes.node_instance_role, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/", "")}"
}
