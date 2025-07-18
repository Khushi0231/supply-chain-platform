provider "aws" {
  region = "us-east-1"
}
resource "aws_s3_bucket" "data_bucket" {
  bucket = "supply-chain-data-${random_string.suffix.result}"
}
resource "random_string" "suffix" {
  length  = 8
  special = false
}
resource "aws_dynamodb_table" "inventory" {
  name           = "Inventory"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "product_id"
  attribute {
    name = "product_id"
    type = "S"
  }
}