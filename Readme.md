# 🚀 Terraform EC2 Setup with Java and Maven Installation

This repository contains Terraform code to provision an AWS EC2 instance and automatically install **Java** and **Maven** using a `user_data` script.

---

## 📦 What This Terraform Setup Does

- Creates an AWS EC2 instance
- Installs Java (e.g., JDK 21)
- Installs Maven (e.g., 3.9.10)
- Sets `JAVA_HOME` and `MAVEN_HOME` environment variables
- Writes logs to `/var/log/cloud-init-output.log`

---

## 🛠️ Prerequisites

Before you begin, make sure you have the following installed:

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- An AWS account and access credentials

---

## 🔐 Configure AWS Credentials

```bash
aws configure
```

You’ll be prompted to enter:

- AWS Access Key ID
- AWS Secret Access Key
- Default region name (e.g., `us-east-1`)
- Default output format (optional)

---

## 🧾 Usage

### 1. Clone the Repository

```bash
git clone https://github.com/rajgupta2/tech_eazy_devops_rajgupta2.git
cd your-repo-name
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the Terraform Plan (optional)

```bash
terraform plan
```

### 4. Apply the Terraform Configuration

```bash
terraform apply
```

Type `yes` when prompted.

---

## 🔍 What to Expect

- Terraform will launch an EC2 instance.
- The instance will automatically install Java and Maven.
- Log output will be available at:

  ```bash
  /var/log/cloud-init-output.log
  # and also available at S3 Bucket and also app logs be there.
  ```

---

## ⚙️ Configuration

You can modify the following files:

- `main.tf`: AWS provider and EC2 instance configuration
- `user_data.sh`: Script to install and configure software on EC2
- `variables.tf`: Input variables (like AMI ID, instance type, etc.)
- `outputs.tf`: Outputs (like instance public IP)

---

## 🧼 Clean Up

To destroy all resources created by Terraform:

```bash
terraform destroy
```

---

## 🤝 Contributing

Feel free to fork this repo, open issues, or submit PRs to improve the setup.

---
