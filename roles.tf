resource "aws_iam_role" "ec2_iam_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "ec2-instance-iam-role"
  }
}
resource "aws_iam_policy" "policy" {
  name        = "ec2-instance-policy"
  description = "My ec2 instance policy"


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    "name" = "ec2_instance_policy"
  }
}
resource "aws_iam_role_policy_attachment" "policy_role_attach" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "instance_prof" {
  name = "aws_instance_profile"
  role = aws_iam_role.ec2_iam_role.name
}