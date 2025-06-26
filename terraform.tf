provider "aws" {
  region  = "us-east-1"
  version = "~> 1.0"
}

# Vulnerability: EC2 IAM roles vulnerable to SSRF attacks (IMDSv1 enabled)
resource "aws_instance" "old_server" {
  ami           = "ami-0e9999fakelegacy"
  instance_type = "t2.micro"
  
  # VULNERABILITY: IMDSv1 enabled - vulnerable to SSRF attacks
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"  # Should be "required" for IMDSv2
  }
  
  user_data = <<-EOF
    #!/bin/bash
    yum install -y php-5.4 mysql
  EOF
}

# Vulnerability: IAM Policy has wildcard write actions defined
resource "aws_iam_policy" "vulnerable_policy" {
  name = "VulnerablePolicy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject*",
          "s3:DeleteObject*",
          "ec2:*",
          "iam:*"
        ]
        Resource = "*"  # VULNERABILITY: Wildcard resource allowing actions on any resource
      }
    ]
  })
}

# Vulnerability: Load balancer is using outdated TLS policy
resource "aws_lb" "vulnerable_alb" {
  name               = "vulnerable-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-12345678", "subnet-87654321"]
}

resource "aws_lb_listener" "vulnerable_listener" {
  load_balancer_arn = aws_lb.vulnerable_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  
  # VULNERABILITY: Using outdated TLS policy
  ssl_policy = "ELBSecurityPolicy-TLS-1-1-2017-01"  # Should use newer policy like ELBSecurityPolicy-TLS-1-2-2017-01
  
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vulnerable_tg.arn
  }
}

resource "aws_lb_target_group" "vulnerable_tg" {
  name     = "vulnerable-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-12345678"
}

# Vulnerability: S3 Buckets should have block public access globally
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "my-vulnerable-test-bucket-12345"
  
  # VULNERABILITY: No public access block configuration
  # Missing aws_s3_bucket_public_access_block resource
}

# Vulnerability: Deletion protection is disabled for RDS database
resource "aws_db_instance" "vulnerable_db" {
  identifier = "vulnerable-database"
  engine     = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  
  allocated_storage = 20
  storage_type      = "gp2"
  
  db_name  = "testdb"
  username = "admin"
  password = "password123"  # Also bad practice but not in the list
  
  # VULNERABILITY: Deletion protection disabled
  deletion_protection = false  # Should be true
  
  skip_final_snapshot = true
}

# Vulnerability: AWS ElastiCache Redis cluster should have encryption at rest enabled
resource "aws_elasticache_replication_group" "vulnerable_redis" {
  replication_group_id         = "vulnerable-redis"
  description                  = "Vulnerable Redis cluster"
  
  node_type            = "cache.t3.micro"
  port                 = 6379
  parameter_group_name = "default.redis7"
  
  num_cache_clusters = 2
  
  # VULNERABILITY: Encryption at rest disabled
  at_rest_encryption_enabled = false  # Should be true
  
  # VULNERABILITY: Encryption in transit disabled  
  transit_encryption_enabled = false  # Should be true
  
  subnet_group_name = aws_elasticache_subnet_group.vulnerable_subnet_group.name
}

resource "aws_elasticache_subnet_group" "vulnerable_subnet_group" {
  name       = "vulnerable-cache-subnet"
  subnet_ids = ["subnet-12345678", "subnet-87654321"]
}
