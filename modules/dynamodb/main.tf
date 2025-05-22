resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = "S"  # 文字列型
  }

  tags = {
    Name = var.table_name
    Env  = var.env
  }
}
