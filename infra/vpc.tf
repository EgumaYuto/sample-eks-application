resource "aws_vpc" "vpc" {
  cidr_block         = local.cidr_block
  enable_dns_support = true
}

resource "aws_flow_log" "log" {
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.flow_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id
}

resource "aws_cloudwatch_log_group" "flow_log_group" {
  name = local.vpc.flow_log.name
}

data "aws_iam_policy_document" "flow_log_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["vpc-flow-logs.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "flow_log_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = [
      aws_cloudwatch_log_group.flow_log_group.arn,
      "${aws_cloudwatch_log_group.flow_log_group.arn}/*"
    ]
  }
}

resource "aws_iam_role" "flow_log_role" {
  name               = local.vpc.flow_log.name
  assume_role_policy = data.aws_iam_policy_document.flow_log_assume_policy.json
}

resource "aws_iam_policy" "flow_log_policy" {
  name   = local.vpc.flow_log.name
  policy = data.aws_iam_policy_document.flow_log_policy.json
}

resource "aws_iam_role_policy_attachment" "flow_log_policy_attachment" {
  role       = aws_iam_role.flow_log_role.id
  policy_arn = aws_iam_policy.flow_log_policy.arn
}