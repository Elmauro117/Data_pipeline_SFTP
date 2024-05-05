
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




resource "aws_iam_role_policy_attachment" "sft_attach_policy" {
  role       = aws_iam_role.sftp_role.name
  policy_arn = aws_iam_policy.sftp_policy.arn
}

//deployment of the SFTP
resource "aws_transfer_server" "example" {
  endpoint_type = "PUBLIC"
  logging_role  = aws_iam_role.sftp_role.arn    ///// sdadasdasdasd

  protocols   = ["SFTP"]
  #certificate = aws_acm_certificate.example.arn   //////////

  domain = "S3"

  identity_provider_type = "SERVICE_MANAGED"
  
}

//creando el user
resource "aws_transfer_user" "mauro" {
  server_id = aws_transfer_server.example.id
  user_name = "mauro"
  role       = aws_iam_role.sftp_role.arn
  home_directory = "/landing/*"

  tags = {
    Name = "mauro"
  }  
  
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_transfer_ssh_key" "mauro_ssh" {
  server_id  = aws_transfer_server.example.id
  user_name  = aws_transfer_user.mauro.user_name
  
  body       = trimspace(tls_private_key.example.public_key_openssh)
  
  depends_on = [aws_transfer_user.mauro]
}

resource "local_file" "private_key" {
  filename = "D:/ga/clave_ss.pem"
  content  = tls_private_key.example.private_key_pem
}
