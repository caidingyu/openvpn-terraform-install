data "aws_iam_policy_document" "ssm_automation_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ssm_automation" {
  name               = "ssm-automation-ec2-start-stop"
  assume_role_policy = data.aws_iam_policy_document.ssm_automation_trust.json
}

data "aws_iam_policy_document" "ssm_automation_policy" {
  statement {
    actions   = ["ec2:StartInstances", "ec2:StopInstances", "ec2:DescribeInstances"]
    resources = ["*"] # tighten to specific ARNs if you wish
  }
}

resource "aws_iam_policy" "ssm_automation_policy" {
  name   = "ssm-automation-ec2-start-stop"
  policy = data.aws_iam_policy_document.ssm_automation_policy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ssm_automation.name
  policy_arn = aws_iam_policy.ssm_automation_policy.arn
}