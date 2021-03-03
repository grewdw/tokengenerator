resource "aws_iam_instance_profile" "tabwriter_profile" {
  name = "${local.name}-profile"
  role = aws_iam_role.tabwriter_role.name
}

resource "aws_iam_role" "tabwriter_role" {
  name = "${local.name}-role"

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
    Application = local.application
  }
}

resource "aws_iam_role_policy" "tabwriter_policy" {
  name = "${local.name}-policy"
  role = aws_iam_role.tabwriter_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter*",
        ]
        Effect = "Allow"
        Resource = [
          aws_ssm_parameter.auth_token.arn,
          aws_ssm_parameter.apple_music_private_key.arn,
          aws_ssm_parameter.apple_music_key_identifier.arn,
          aws_ssm_parameter.apple_music_team_id.arn
        ]
      },
      {
        Action = [
          "s3:GetObject",
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.tabwriter_s3_bucket.arn}/${aws_s3_bucket_object.cloudwatch_config.id}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "tabwriter_cloudwatch_policy" {
  name = "${local.name}-cloudwatch-policy"
  role = aws_iam_role.tabwriter_role.id

  policy = data.aws_iam_policy.cloudwatch_policy.policy
}

data "aws_iam_policy" "cloudwatch_policy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}