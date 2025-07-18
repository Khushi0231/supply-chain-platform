resource "aws_lambda_function" "file_processor" {
  function_name = "file_processor"
  role          = "<PASTE_IAM_ROLE_ARN_FROM_PERSON_B>"
  handler       = "file_processor.lambda_handler"
  runtime       = "python3.9"
  filename      = "lambda/file_processor.zip"
  source_code_hash = filebase64sha256("lambda/file_processor.zip")
}
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.data_bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.file_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_s3]
}
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data_bucket.arn
}