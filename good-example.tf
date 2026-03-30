
resource "aws_s3_bucket" "secure_data" {
  bucket = "company-secure-data"
  acl    = "public-read"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = "company-logs"
    target_prefix = "s3-access-logs/"
  }

  versioning {
    enabled = true
  }

  tags = {
    Environment = "production"
    Owner       = "devops-team"
    CostCenter  = "engineering"
  }
}

resource "aws_db_instance" "secure_database" {
  identifier           = "production-db"
  engine              = "postgres"
  instance_class      = "db.t3.medium"
  allocated_storage   = 100
  
  storage_encrypted   = true
  publicly_accessible = false
  
  tags = {
    Environment = "production"
    Owner       = "database-team"
    CostCenter  = "engineering"
  }
}

resource "aws_security_group" "restricted_ssh" {
  name        = "restricted-ssh-access"
  description = "SSH only from corporate network"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = {
    Environment = "production"
    Owner       = "security-team"
    CostCenter  = "engineering"
  }
}
# Demo run at Mon 23 Mar 20:21:02 WAT 2026
