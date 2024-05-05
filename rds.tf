
data "aws_vpc" "existing_vpc" {
  tags = {
    Name = "VPC_oc"  # Replace "YourVPCName" with the actual name of your VPC
  }
}


resource "aws_db_instance" "my_database" {
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  engine_version      = "5.7"
  publicly_accessible = true  # Set to true if you want the database to be publicly accessible
  
  identifier       = "db-mauro-gluejob"
  db_name          = "db_name_mauro"  ## Creanis una BD dentro de la BD
  username         = "admin"
  password         = "holamundo"

  parameter_group_name = "default.mysql5.7"

  # Set to true for production deployments
  backup_retention_period = 7
  
  # Set to true if you want to apply automatic minor version upgrades
  auto_minor_version_upgrade = true

  # Configuration for the free tier
  #db_subnet_group_name      = "default"
  skip_final_snapshot       = true

  network_type = "IPV4"

  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  port = "3306"

}




resource "aws_security_group" "rds_security_group" {
  name        = "rds-security-group"
  description = "Security group for RDS allowing traffic on port 3306"

  vpc_id = data.aws_vpc.existing_vpc.id  # Replace with the ID of your VPC

  ingress {
    from_port   = 0
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from any IP address (Internet)
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self = true
  }
  
}