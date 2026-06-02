resource "aws_lambda_function" "myfunc" {
  filename         = "${path.module}/lambda/func.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/func.zip")

  function_name = "nathan-resume-platform"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "func.lambda_handler"
  runtime       = "python3.12"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "nathan_resume_platform_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy_for_resume_project" {
  name        = "nathan_resume_platform_lambda_policy"
  path        = "/"
  description = "IAM policy for the AWS Resume Platform Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:PutItem"
        ]
        Resource = "arn:aws:dynamodb:*:*:table/nathan-resume-platform"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_resume_project.arn
}

resource "aws_lambda_function_url" "url1" {
  function_name      = aws_lambda_function.myfunc.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins = [
      "https://platform.nathan-resume.com",
      "https://d1yd9qn7a5bnqz.cloudfront.net"
    ]
    allow_methods = ["GET"]
    allow_headers = ["*"]
    expose_headers = ["*"]
    max_age = 86400
  }
}

output "lambda_function_url" {
  value = aws_lambda_function_url.url1.function_url
}

