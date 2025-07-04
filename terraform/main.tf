terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
}

resource "aws_instance" "webserver-techeazy" {
  ami                    = var.ami_value
  instance_type          = var.instance_type_value
  subnet_id              = var.subnet_id_defaultVPC
  iam_instance_profile   = aws_iam_instance_profile.ec2-instance-profile.name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.techeazy-security-group.id]
  user_data = base64encode(templatefile("../scripts/user_data.sh",{
    STOP_INSTANCE       = var.stop_after_minutes # Match STOP_INSTANCE in script
    S3_BUCKET_NAME      = var.s3_bucket
    EC2-Instance  = var.instance_name
  }))
  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "techeazy-security-group" {
  name = "webig"

  ingress {
    description = "HTTP from vpc"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Web.sg"
  }
}

resource "aws_s3_bucket" "S3_bucket_For_Logs" {
  bucket = var.s3_bucket
  force_destroy = true
  tags = {
    Name = var.s3_bucket
  }
}

resource "aws_iam_role" "EC2-S3-Role" {
  name = "EC2-S3-Role-With-S3-Bucket-write-access"
  description = "This is a role that allow to create buckets and upload objects."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "EC2-S3-Role"
  }
}
resource "aws_iam_policy" "policy_for_s3_bucket_creation_and_upload_objects" {
  name        = "policy_for_s3_bucket_creation_and_upload_objects_with_bucket_${var.s3_bucket}"
  description = "This is a policy that allows bucket creation and uploading objects."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
            "s3:CreateBucket"
        ]
        Resource = "arn:aws:s3:::*"
      },
      {
        Effect = "Allow"
        Action = [
            "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::${var.s3_bucket}/*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "attach_create_upload_access" {
  role       = aws_iam_role.EC2-S3-Role.name
  policy_arn = aws_iam_policy.policy_for_s3_bucket_creation_and_upload_objects.arn
}

#Creating instance profile so that we can attach it to ec2
resource "aws_iam_instance_profile" "ec2-instance-profile" {
  name = "ec2-s3-instance-profile_${var.ami_value}"
  role = aws_iam_role.EC2-S3-Role.name
}

resource "aws_iam_policy" "policy_for_S3_Bucket_Read_Access" {
  name        = "policy_for_S3_Bucket_Read_Access"
  description = "This is a policy that allow to read Objects in a specific bucket."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect="Allow"
        Action=[
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource="arn:aws:s3:::${var.s3_bucket}/*"
      }
    ]
  })
}

resource "aws_iam_role" "S3-Read-Role" {
  name = "S3-Read-Role-for-bucket-${aws_s3_bucket.S3_bucket_For_Logs.id}"
  description = "This is a role that allow to read objects of specific bucket."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "S3-Read-Role"
  }
}

resource "aws_iam_role_policy_attachment" "attach_s3_read_access" {
  role       = aws_iam_role.S3-Read-Role.name
  policy_arn = aws_iam_policy.policy_for_S3_Bucket_Read_Access.arn
}

# resource "aws_iam_role_policy_attachment" "attach_read_access" {
#   role       = aws_iam_role.EC2-S3-Role.name
#   policy_arn = aws_iam_policy.policy_for_S3_Bucket_Read_Access.arn
# }


resource "aws_s3_bucket_lifecycle_configuration" "S3_bucket_LifeCycle" {
  bucket = aws_s3_bucket.S3_bucket_For_Logs.id

  rule {
    id = "rule-1"

    # ... other transition/expiration actions ...
    status = "Enabled"

    filter {
      prefix = "app/logs/"
    }

    expiration {
      days = abs(7)
    }
  }
}