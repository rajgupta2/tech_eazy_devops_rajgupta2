# 🚀 Assignment-03 (Github Action Integration)

This repository contains Terraform code to launch an AWS EC2 instance  and  create an s3 bucket to store logs. You can use this repo as

- ✅ **Locally** on your machine
- ✅ **Automatically** through a **GitHub Actions** workflow

---

## 📋 Prerequisites for GitHub Actions

### 1. ✅ Fork the Repository
  Click on the fork button at the top right of this GitHub repo to create your own copy.

### 2. 🔐 Configure AWS Credentials in GitHub
You need an **AWS IAM user** with **programmatic access**. Set your AWS credentials as repository secrets:

Navigate to:
`Settings` > `Secrets and variables` > `Actions` > `New repository secret`

Add the following secrets:
- `AWS_ACCESS_KEY_ID`: Your AWS Access Key ID
- `AWS_SECRET_ACCESS_KEY`: Your AWS Secret Access Key

### 3. 🪣 Create an S3 Bucket to manage Terraform State file so that you can also delete the infrastructure using github actions
- Create a **globally unique** S3 bucket.
- Configure the S3 bucket name in the `bucket` attribute inside the `backend.tf` file located in the `./terraform/` directory.
- Commit the updated `backend.tf`.

This ensures the Terraform state is stored remotely and allows GitHub Actions to manage infrastructure across runs.

### 4. 🚀 Run the Deploy Workflow

To create AWS resources:

- Go to the **Actions** tab in your GitHub repo.
- Select the `Deploy.yml` workflow.
- Click **"Run workflow"**.

This will automatically provision the EC2 instance and the S3 bucket and validate **application hosting**.

### 5. 🧹 Run the Destroy Workflow

To delete all AWS resources created by Terraform:

- Go to the **Actions** tab.
- Select the `Destroy.yml` workflow.
- Click **"Run workflow"**.

---


## 🛠️ Prerequisites for local setup

Before you begin, make sure you have the following installed:

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- An AWS account and access credentials

---

### 🔐 Configure AWS Credentials

Run:

```bash
aws configure
```

You’ll be prompted to enter:

- AWS Access Key ID
- AWS Secret Access Key
- Default region name (e.g., `ap-south-1`)
- Default output format (optional)

---

## 💻 Local Usage Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/rajgupta2/tech_eazy_devops_rajgupta2.git
cd tech_eazy_devops_rajgupta2/terraform
```

### 2. Delete the `backend.tf` File

> ⚠️ Since you are running Terraform locally, remove the `backend.tf` file from the `./terraform/` directory.
> This file is used only for remote terraform state management (like in GitHub Actions).

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Terraform Plan (optional)

```bash
terraform plan
```

### 5. Apply the Terraform Configuration

```bash
terraform apply
```

Type `yes` when prompted.

---

### 🔍 What to Expect

- An EC2 instance will be provisioned.
- Java and Maven will be installed automatically on the instance.
- Logs will be stored in the configured **S3 bucket**.
- Application will be deployed successfully.
- You can also read log by connecting to `EC2-instances: InstanceWithS3ReadsAccess` and running below command.
    ```bash
        aws s3 ls s3://logs-bucket-rajgupta2-ap-south-1 #This lists all top-level files/folders in the bucket. Make sure you change the bucket name according to your if you configure your bucket name.
        aws s3 cp s3://logs-bucket-rajgupta2-ap-south-1/app/logs/file_name.log . #You need to configure file name in above script..
        cat file_name.log #to read the log
    ```

---


## 🧼 Clean Up Locally

To avoid charges, destroy all resources created by Terraform:

```bash
terraform destroy
```

Confirm by typing `yes`.

---

## 🤝 Contributing

Feel free to fork this repo, open issues, or submit PRs to improve the setup.

---
