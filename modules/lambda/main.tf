resource "aws_lambda_function" "this" {
  function_name = var.function_name
  filename      = "${path.module}/src/lambda.zip"
  handler       = "lambda_function.handler"
  runtime       = "python3.11"
  role          = var.iam_role_arn

  source_code_hash = filebase64sha256("${path.module}/src/lambda.zip")
  environment {
    variables = {
      ENV = var.env
    }
  }
}

variable "function_name" {}
variable "iam_role_arn" {}
variable "env" {}

output "lambda_arn" {
  value = aws_lambda_function.this.arn
}
