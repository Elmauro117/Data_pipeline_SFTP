



# Attach S3 policy to Lambda role
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.lambda_role.name  ### ROL, es a si mismo recurso usado
  policy_arn = aws_iam_policy.s3_policy.arn  ### POLICY, es para acceder a otro
}
resource "aws_iam_role_policy_attachment" "glue_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.glue_policy.arn
}
resource "aws_iam_role_policy_attachment" "lambda_basic_execution_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambdas_basic_exec_rol.arn
}

# Attach S3 policy to Lambda_RDS role

resource "aws_iam_role_policy_attachment" "s3_policy_attachment_rds" {
  role       = aws_iam_role.lambda_role_rds.name  ### ROL, es a si mismo recurso usado
  policy_arn = aws_iam_policy.s3_policy.arn  ### POLICY, es para acceder a otro
}
/*
resource "aws_iam_role_policy_attachment" "glue_policy_attachment_rds" {
  role       = aws_iam_role.lambda_role_rds.name
  policy_arn = aws_iam_policy.glue_policy.arn
}
*/
resource "aws_iam_role_policy_attachment" "RDS_policy_attachment_rds" {
  role       = aws_iam_role.lambda_role_rds.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
resource "aws_iam_role_policy_attachment" "lambda_basic_execution_attachment_rds" {
  role       = aws_iam_role.lambda_role_rds.name
  policy_arn = aws_iam_policy.lambdas_basic_exec_rol_2.arn
}


# Lambda function INGESTION
resource "aws_lambda_function" "lambda_ingestion" {
  function_name = "Lambda_ingestion" 
  role          = aws_iam_role.lambda_role.arn
  handler       = "cod_lambda_ingestion.lambda_handler"  ###
  runtime       = "python3.8"
  timeout       = 123  # 2 minutes and 3 seconds (123 seconds)

  s3_bucket = "your s 3 bucket"
  s3_key    = "cod_lambda_ingestion.zip"

  # Other Lambda function configuration as needed
}

# Lambda function RDS
resource "aws_lambda_function" "lambda_rds" {
  function_name = "Lambda_rds"  
  role          = aws_iam_role.lambda_role_rds.arn
  handler       = "lambda_rds.lambda_handler"
  runtime       = "python3.10"
  timeout       = 123  # 2 minutes and 3 seconds (123 seconds)

  s3_bucket = "your s 3 bucket"
  s3_key    = "lambda_rds.zip"

  layers    = [aws_lambda_layer_version.my_layer.arn]
}

// Crear el LAMBDA LAYER
resource "aws_lambda_layer_version" "my_layer" {
  layer_name = "my-layer"
  compatible_runtimes = ["python3.10"]
  s3_bucket = "your s 3 bucket"
  s3_key    = "python_layer.zip"
}




// Creando Triggers
resource "aws_lambda_permission" "s3_trigger" {
  statement_id  = "AllowS3Invocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_ingestion.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.s3_bu.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${data.aws_s3_bucket.s3_bu.bucket}" ## required as string to function

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_ingestion.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "landing/"
  }
}


// Solo se puede crear un trigger desde el mismo S3 1 vez, no dos. Si quieres q sea dos debe ser manual

//Triggrer para el LAMBDA RDS
/*
resource "aws_lambda_permission" "s3_trigger_rds_lambda" {
  statement_id  = "AllowS3Invocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_rds.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.s3_bu.arn
}

resource "aws_s3_bucket_notification" "bucket_notification_rds_lambda" {
  bucket = "${data.aws_s3_bucket.s3_bu.bucket}" ## required as string to function

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_rds.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "publish/"
  }
}
*/