# INSECURE Infrastructure - Will FAIL security scan

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}

resource "aws_s3_bucket" "public_website" {
  bucket = "company-public-data"
  acl    = "public-read"
}

resource "aws_db_instance" "exposed_database" {
  identifier           = "customer-database"
  engine              = "mysql"
  instance_class      = "db.m5.24xlarge"
  allocated_storage   = 1000
  
  storage_encrypted   = false
  publicly_accessible = true
  
  username = "admin"
  password = "Password123!"
}

resource "aws_security_group" "wide_open" {
  name        = "allow-everything"
  description = "Open to the world"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Updated Sun 22 Mar 21:53:09 WAT 2026
