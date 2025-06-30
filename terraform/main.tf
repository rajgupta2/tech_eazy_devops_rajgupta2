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
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.techeazy-security-group.id]
  iam_instance_profile   = aws_iam_instance_profile.s3_creator_uploader_profile.name

  user_data = base64encode(file("../scripts/user_data.sh",))

  tags = {
    Name = "MyInstance-techeazy"
  }

  depends_on = [
    aws_s3_bucket.techeazy-s3-bucket
  ]
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

resource "aws_s3_bucket" "techeazy-s3-bucket" {
  bucket = var.s3_bucket_name

  force_destroy = true

  tags = {
    Name        = "techeazy bucket"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "techeazy-s3-bucket" {
  bucket = aws_s3_bucket.techeazy-s3-bucket.id

  rule {
    id     = "delete_app_logs_after_7_days"
    status = "Enabled"

    filter {
      prefix = "app/logs/"
    }

    expiration {
      days = 7
    }
  }
}


resource "aws_iam_role" "techeazy_iam__s3_role" {
  name = "techeazy_iam_s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "S3CreatorUploaderRole"
  }
}

resource "aws_iam_policy" "s3_creator_uploader_policy" {
  name        = "s3_creator_uploader_policy"
  description = "Provides permissions to create S3 buckets and upload objects, explicitly denying read/download"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:CreateBucket",
          "s3:PutObject",
          "s3:PutObjectAcl",
        ]
        Resource = "*"
      },
      {
        Effect   = "Deny"
        Action   = [
          "s3:Get*",
          "s3:List*",
        ]
        Resource = "*"
      },
    ]
  })
}

# Attach S3 Creator/Uploader Policy to the Role
resource "aws_iam_role_policy_attachment" "s3_creator_uploader_attachment" {
  role       = aws_iam_role.techeazy_iam__s3_role.name
  policy_arn = aws_iam_policy.s3_creator_uploader_policy.arn
}

# --- IAM Instance Profile for S3 Creator/Uploader Role ---
# An instance profile is required to attach an IAM role to an EC2 instance.
resource "aws_iam_instance_profile" "s3_creator_uploader_profile" {
  name_prefix = "s3-creator-uploader-profile"
  role = aws_iam_role.techeazy_iam__s3_role.name # Reference the role created above

  tags = {
    Name = "S3CreatorUploaderInstanceProfile"
  }
}