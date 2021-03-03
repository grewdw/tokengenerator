resource "aws_cloudwatch_log_group" "tabwriter_log_group" {
  name              = "${local.name}-log-group"
  retention_in_days = 365

  tags = {
    Application = "TabWriter"
  }
}

resource "aws_cloudwatch_log_stream" "nginx_access_log_stream" {
  name           = "nginx_access_log"
  log_group_name = aws_cloudwatch_log_group.tabwriter_log_group.name
}

resource "aws_cloudwatch_log_stream" "nginx_error_log_stream" {
  name           = "nginx_error_log"
  log_group_name = aws_cloudwatch_log_group.tabwriter_log_group.name
}
