# combined policy for both S3 and CLoudwatch logs

resource "aws_iam_role" "role_b_combined" {
  count = var.stage =="dev" ? 1:0
  name = "s3_and_cloudwatch_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "s3_and_cloudwatch_policy" {
  count = var.stage =="dev" ? 1:0
  name        = "cloudwatch_s3_combined_policy"
  description = "Allows Ec2 logs upload to cloudwatch and S3 "

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:CreateBucket",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = ["arn:aws:s3:::${var.log_s3_bucket_name}", 
                    "arn:aws:s3:::${var.log_s3_bucket_name}/*"]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "cloudwatch:PutMetricData"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_and_cloudwatch_policy_attach" {
  count = var.stage =="dev" ? 1:0
  role       = aws_iam_role.role_b_combined[0].name
  policy_arn = aws_iam_policy.s3_and_cloudwatch_policy[0].arn
}

data "aws_iam_role" "role_b_combined" {
  count = var.stage =="prod" ? 1:0
  name = "s3_cloudwatch_role"
}
