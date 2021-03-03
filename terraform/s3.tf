resource "aws_s3_bucket" "tabwriter_s3_bucket" {
  bucket = "${local.name}-resources"
  acl    = "private"
  tags = {
    Application = "TabWriter"
  }
}

resource "aws_s3_bucket_object" "cloudwatch_config" {
  bucket = aws_s3_bucket.tabwriter_s3_bucket.id
  key    = "cloudwatch_log_config.txt"
  content = templatefile("${path.root}/templates/cloudwatch_log_config.json.tpl", {
    LOG_GROUP_NAME     = aws_cloudwatch_log_group.tabwriter_log_group.name
    ACCESS_STREAM_NAME = aws_cloudwatch_log_stream.nginx_access_log_stream.name
    ERROR_STREAM_NAME  = aws_cloudwatch_log_stream.nginx_error_log_stream.name
  })
  etag = filemd5("${path.root}/templates/cloudwatch_log_config.json.tpl")
}