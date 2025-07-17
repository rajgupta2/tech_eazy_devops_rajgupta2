# These are varibles values that terraform uses at real time while creating aws resources.
# You can edit these values.
# If you remove any lines then terraform will use default value that is given in variable.tf file.

aws_region            = "ap-south-1"
ami_value             = "ami-018046b953a698135"
subnet_id_defaultVPC  = "subnet-0850ced02e7902d56"
instance_type_value   = "t3.micro"
instance_name_s3_read = "techeazyS3ReadsAccess"
key_name_value        = "new-key.pem"
s3_bucket          = "logs-bucket-rajgupta2-ap-south-1"