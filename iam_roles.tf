# IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    "Version"   : "2012-10-17",
    "Statement" : [{
      "Effect"    : "Allow",
      "Principal" : {
        "Service" : "lambda.amazonaws.com"
      },
      "Action"    : "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "lambda_role_rds" {
  name = "lambda_role_rds"

  assume_role_policy = jsonencode({
    "Version"   : "2012-10-17",
    "Statement" : [{
      "Effect"    : "Allow",
      "Principal" : {
        "Service" : "lambda.amazonaws.com"
      },
      "Action"    : "sts:AssumeRole"
    }]
  })
}


# Rol Glue
resource "aws_iam_role" "glue_role" {
  name               = "glue-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "sftp_role" {
  name = "sftp_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "clouddirectory.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}






# IAM policy for S3 access
resource "aws_iam_policy" "s3_policy" {
  name        = "s3_policy"
  description = "Policy for accessing S3"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect"   : "Allow",
      "Action"   : [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource" : "arn:aws:s3:::*"
    }]
  })
}

# IAM policy for Glue job execution
resource "aws_iam_policy" "glue_policy" {
  name        = "glue_policy"
  description = "Policy for executing Glue jobs"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect"   : "Allow",
      "Action"   : "glue:StartJobRun",
      "Resource" : "*"
    }]
  })
}

resource "aws_iam_policy" "lambdas_basic_exec_rol" {
  name        = "basic_exec_rol"
  description = "permite crear logs en la lambda"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_policy" "lambdas_basic_exec_rol_2" {
  name        = "basic_exec_rol_rds"
  description = "para ejecutar una lambda y permitir crear logs"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
})
}

// Transfer Policy
resource "aws_iam_policy" "sftp_policy" {
  name        = "sftp_policy"
  description = "allow acces to an s3 bucket"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::aws-codestar-us-east-1-691119770807"
            ],
            "Effect": "Allow",
            "Sid": "ReadWriteS3"
        },
        {
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:GetObjectVersion",
                "s3:GetObjectACL",
                "s3:PutObjectACL"
            ],
            "Resource": [
                "arn:aws:s3:::aws-codestar-us-east-1-691119770807"
            ],
            "Effect": "Allow",
            "Sid": ""
        }
    ]
})
}