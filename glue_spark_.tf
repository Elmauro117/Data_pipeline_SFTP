# Attach Glue policy to glue
resource "aws_iam_role_policy_attachment" "glue_policy_attachment_2" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
}
resource "aws_iam_role_policy_attachment" "glue_policy_attachment_3" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}


/// Configuramos el glue Job
resource "aws_glue_job" "test_glue" {
  name          = "test_glue"
  role_arn      = aws_iam_role.glue_role.arn
  command {
    name    = "glueetl"
    script_location = "s3://your s 3 bucket/glue_spark_script.py"  # Replace with your script location in S3
    python_version = "3"
  }
  max_capacity  = 10
 # max_concurrent_runs = 10

}


