# Techeazy AWS Internship-DEVOPS ASSIGNMENT-1 – EC2 Java App Deployment with Terraform

## 📌 Overview

This project automates the deployment of a Java 21 application on an AWS EC2 instance using Terraform. The setup installs dependencies, deploys the app, and verifies it is running on **port 80**.

## 🛠️ Tech Stack

- **AWS EC2**
- **Terraform**
- **Java 21**
- **Postman** (for testing API endpoints)

## 🚀 Steps to Deploy

1. **Clone this repo:**
   
   bash``
   git clone https://github.com/devops-nikki/tech_eazy_devops-nikki_aws_devops.git   
   cd tech_eazy_devops-nikki_aws_devops

2. **Set your AWS credentials as environment variables:**

   export AWS_ACCESS_KEY_ID=your_key

   export AWS_SECRET_ACCESS_KEY=your_secret_key


3. **Initialize and apply Terraform:**

   terraform init
   terraform validate
   terraform plan
   terraform apply


4. **Wait a few minutes until the app is reachable on the EC2 public IP via port 80.**


5. **Test API endpoints using Postman:**

   -Import the .json file from the resources folder

   -Update the base URL with your EC2 public IP

   -Run requests to verify the app is up


   **🔐 Notes**

   -No credentials are hardcoded in the repo

   -Root user was used only for demo purposes

   -Elastic IP not used (public IP will change if instance is stopped)

   **🔍 Your Output Should Look Like:**

   **✅ API Working via Postman:**

   ![Java App Output](Output_ss/postman_.png)

   **✅ JAVA App deployment Through Browser:**
  ![Java App_browser_Output](Output_ss/ec2-deployed.png)
   
   **✅ After all the setup don't forget to run:**(for cost-saving)
     terraform destroy

# ✅ Techeazy AWS Internship -DevOps Assignment 2 – IAM, S3, Log Upload (Completed)

## 📌 Overview

This assignment automates secure log archival from EC2 instances to a private Amazon S3 bucket using Terraform and a Bash script. The project demonstrates key DevSecOps principles, including:

- IAM policy control
- EC2 lifecycle automation
- S3 lifecycle configuration
- Secure log upload and verification

---

## ✅ Completed Tasks

### 🔐 IAM Roles

- Created two custom IAM policies:
  - `ReadOnlyAccessToS3`
  - `WriteOnlyAccessToS3`
- Attached policies to respective roles using IAM Instance Profiles for **least privilege** access.

### 🪣 S3 Bucket Setup

- Created a **private** S3 bucket (`techeazy-logs-bucket-nikki`)
- Enabled **block public access**
- Configured **lifecycle rule** to clean logs older than 7 days

### 💻 EC2 Log Upload Automation

- Captured logs from `/var/log/my-app.log` 
- uploaded to S3 on **shutdown**
- Fully automated using:
  - Bash script: `user_data.sh.tf.tpl`
  - IAM write role

### 📂 Terraform Code Structure

| File | Description |
|------|-------------|
| `main.tf` | EC2 and networking setup |
| `iam_role_a.tf` and `iam_role_b.tf`| IAM policies and roles |
| `s3_bucket.tf` | S3 bucket creation and lifecycle rule |
| `user_data.sh.tftpl` | Bash script for uploading logs |
| `README.md` | Documentation |

---

## 🔍 Log Verification

- ✅ Successfully uploaded logs to S3 (`app_logs/`, `system_logs/`)
- ✅ Verified **read-only** access from another EC2 instance using the `ReadOnlyAccessToS3` IAM role through AWS-CLI

## 🚀 How to Deploy

```bash
terraform init
terraform apply -var-file="your .tfvars file"

📁 Files Modified
main.tf
s3_bucket.tf
user_data.sh.tftpl
terraform.tfvars
README.md

## 🖼️ Deployment Screenshots

### ✅ Deployment Output
> `"Successfully Deployed"`
EC2 deployed (output_ss/public_ip.png)

### ✅ EC2 Instances Running
![EC2 Instances](output_ss/ec2.png)

### ✅ S3 bucket created
![S3_bucket](output_ss/s3_bucket.png)

### ✅ Logs in S3
- `/app_logs/` → (output_ss/app_logs.png)
- `/system_logs/` → (output_ss/system_logs.png)

### ✅ verify role_a
-`verify_role_a`  → (output_ss/verify_role_a.png)
---

## 🚀 How to Deploy

```bash
terraform init
terraform apply -var-file="your .tfvars file"

📁 Files Modified
main.tf
s3_bucket.tf
user_data.sh.tftpl
terraform.tfvars
README.md

 **✅ After all the setup don't forget to run:**(for cost-saving)
     terraform destroy

## 🧑‍🤝‍🧑 Collaborators Invited-
All teammates and mentors have been added as collaborators to the GitHub repository.

## 🔁 Pull Request Notes

Let me know if you'd like to merge the PR or wait for mentor approval.
Thank you for reviewing! 😊

# 📦 Assignment 3 – CI/CD Deployment with GitHub Actions, Custom VPC, EC2 & S3

## 📁 Objective

Automate infrastructure provisioning and deployment of a Java web application using:
- **Terraform** for AWS infrastructure (VPC, EC2, S3, IAM)
- **GitHub Actions** for CI/CD
- **Health check** for the deployed application
- **Log archival** from EC2 to S3

---

## 🛠️ What Was Done

### ✅ Infrastructure Setup via Terraform
- Created a **custom VPC** with public subnet
- Launched an **EC2 instance** inside the VPC
- Attached **IAM instance profile (Role B)** to allow S3 upload
- Created an **S3 bucket** to store logs
- EC2 user data script uploads application logs to S3 during boot

### ✅ GitHub Actions (`deploy.yml`)
- Configured AWS credentials using GitHub Secrets
- Automatically runs on `push` or `tag` to `feature/assignment-3`
- Executes `terraform init`, `plan`, and `apply` to create infra
- Uses `curl` to validate app is live on port 80 via EC2 public IP

---

## 🚀 Deployment Workflow

### 📂 Trigger
The workflow is triggered on `git push` to the `feature/assignment-3` branch.

### 🧩 Steps in `.github/workflows/deploy.yml`
1. **Checkout Code**
2. **Setup Terraform**
3. **Configure AWS Credentials**
4. **Terraform Init + Apply**
5. **Check App Health via curl**
6. **Finish**

---

## 🧪 Health Check

After deployment, the workflow:
- Retrieves EC2 instance public IP (tagged `AppServer-*`)
- Executes a `curl` request on `http://<EC2_IP>`
- Fails the workflow if app doesn't respond after retries

---

## 📦 Log Archival

- EC2 runs a `user_data.sh` script that compresses and uploads logs to the S3 bucket.
- Bucket name and file path are passed through Terraform variables and instance profile.

## 🧾 Folder Structure
techeazy-assignment/
├── Output_ss/
│   ├── app_logs.png
│   ├── ec2-deployed.png
│   ├── ec2.png
│   ├── postman.png
│   ├── public_ip.png
│   ├── s3_bucket.png
│   ├── system_logs.png
│   └── verify_role_a.png
│
├── ec2-deployment/
│   ├── iam_instance_profile.tf
│   ├── iam_role_a.tf
│   ├── iam_role_b.tf
│   ├── main.tf
│   ├── output.tf
│   ├── s3_bucket.tf
│   ├── vpc.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   └── scripts/
│       └── user_data.sh.tftpl
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── Techeazy AWS internship API.postman_collection (1).json
└── README.md

## 🔐 GitHub Secrets Used

| Secret Name           | Purpose                      |
|-----------------------|------------------------------|
| `AWS_ACCESS_KEY_ID`   | Access key for AWS IAM user  |
| `AWS_SECRET_ACCESS_KEY` | Secret key for AWS IAM user  |


## 🧹 Cleanup

To avoid AWS charges, run:

```bash
terraform destroy

**🙌 Author**        

  Nikki Goyal
  Techeazy AWS Internship | June 2025

