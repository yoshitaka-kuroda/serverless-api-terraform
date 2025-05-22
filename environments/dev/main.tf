module "dynamodb" {
  source     = "../../modules/dynamodb"
  table_name = "todo-table"
  hash_key   = "id"
  env        = "dev"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

module "lambda" {
  source         = "../../modules/lambda"
  function_name  = "hello-lambda"
  iam_role_arn   = aws_iam_role.lambda_exec.arn
  env            = var.env
}

module "apigw" {
  source    = "../../modules/apigw"
  api_name  = "my-http-api"
  lambda_arn = module.lambda.lambda_arn
}
