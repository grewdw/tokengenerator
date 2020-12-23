resource "aws_iam_role" "tabwriter_task_execution_role" {
  name = "tabwriter-task-execution-role"
  assume_role_policy = templatefile("templates/assume_role_policy.json.tpl" , {})
  tags = {
    application = "TabWriter"
  }
}

resource "aws_iam_policy" "tabwriter_task_execution_policy" {
  name        = "tabwriter_task_execution_policy"
  description = "Policy for TabWriter task execution"
  policy = templatefile("templates/role_policy.json.tpl", {})
}

resource "aws_iam_role_policy_attachment" "tabwriter_task_execution_policy_attachment" {
  role       = aws_iam_role.tabwriter_task_execution_role.name
  policy_arn = aws_iam_policy.tabwriter_task_execution_policy.arn
}