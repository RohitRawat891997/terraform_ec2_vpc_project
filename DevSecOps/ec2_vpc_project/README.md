🔥 — this is a **production-level secure Terraform file**.

---

# 🚀 1. Terraform Setup

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.76.0"
    }
  }
}
```

👉 Ye batata hai:

* Terraform AWS provider use karega
* Version locked hai (stable infra ke liye)

---

# 🌍 2. AWS Provider

```hcl
provider "aws" {
  region = "us-east-1"
}
```

👉 Matlab:

* Infrastructure **US East (N. Virginia)** region me create hoga

---

# 📦 3. Local Variables

```hcl
locals {
  aws_vpc_cidr = "192.168.0.0/16"
  my_ip        = "103.181.90.241/32"
}
```

👉 Use:

* VPC ka IP range define kiya
* Tumhara public IP (secure access ke liye)

---

# 📊 4. Data Sources

```hcl
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
```

👉 Ye dynamic info fetch karta hai:

* Available AZs (like us-east-1a, 1b, etc.)
* AWS account ID (KMS policy ke liye)

---

# 🌐 5. VPC (Network Base)

```hcl
resource "aws_vpc" "main"
```

👉 Ye create karta hai:

* Private network (VPC)
* DNS enabled (important for EC2 communication)

---

# 🔐 6. KMS Key (Encryption)

```hcl
resource "aws_kms_key" "logs_key"
```

👉 Purpose:

* Logs ko encrypt karna
* Key rotation enabled (security best practice)

🔥 Important:

* Only **tumhare AWS account ko access** hai (no wildcard)

---

# 📜 7. CloudWatch Logs

```hcl
resource "aws_cloudwatch_log_group" "vpc_flow_logs"
```

👉 Use:

* VPC traffic logs store karta hai
* 365 days retention (compliance)
* KMS encryption enabled

---

# 🔑 8. IAM Role (Flow Logs)

```hcl
resource "aws_iam_role" "flow_logs_role"
```

👉 Role allow karta hai:

* AWS VPC service ko logs bhejne ke liye permission

---

# 📜 9. IAM Policy

```hcl
resource "aws_iam_role_policy" "flow_logs_policy"
```

👉 Allow karta hai:

* Logs create karna
* Logs push karna CloudWatch me

---

# 📡 10. VPC Flow Logs

```hcl
resource "aws_flow_log" "vpc_flow"
```

👉 Ye enable karta hai:

* Network traffic monitoring
* Security + auditing

🔥 Interview line:

> "Flow logs help in monitoring and detecting suspicious traffic"

---

# 🏗️ 11. Subnets (Dynamic)

```hcl
resource "aws_subnet" "main"
```

👉 Ye kya karta hai:

* Har Availability Zone me subnet create karta hai
* CIDR automatically divide karta hai (/24)

---

# 🌍 12. Internet Gateway + Route

```hcl
aws_internet_gateway
aws_route_table
```

👉 Ye allow karta hai:

* Internet access

BUT 👇

👉 Tumhara EC2 public IP use nahi kar raha → secure design

---

# 🔐 13. Default Security Group (Zero Trust)

```hcl
resource "aws_default_security_group"
```

👉 Sab block:

* No ingress ❌
* No egress ❌

🔥 Zero trust model

---

# 🛡️ 14. Custom Security Group

```hcl
resource "aws_security_group" "web_sg"
```

👉 Allow karta hai:

* SSH (22) → sirf tumhara IP
* HTTP (80) → sirf tumhara IP

👉 Outbound:

* HTTP + HTTPS allowed

🔥 Important:

> "No 0.0.0.0/0 inbound → secure infra"

---

# 👤 15. EC2 IAM Role

```hcl
resource "aws_iam_role" "ec2_role"
```

👉 EC2 ko AWS services access dene ke liye role

---

# 🧾 16. Instance Profile

```hcl
aws_iam_instance_profile
```

👉 Role ko EC2 instance se attach karta hai

---

# 🖥️ 17. EC2 Instance (Hardened)

```hcl
resource "aws_instance" "web"
```

👉 Key Features:

### ✅ Security

* No public IP → private instance
* IMDSv2 enabled (metadata secure)
* Encrypted disk

### ✅ Performance

* EBS optimized
* Monitoring enabled

### ✅ Access

* Only via your IP (security group)

---

# 📤 18. Output

```hcl
output "vpc_id"
```

👉 Terraform output me VPC ID show karega

---

# 🔥 FINAL SUMMARY (Interview Ready)

👉 Ye pura infra follow karta hai:

* ✅ Least Privilege IAM
* ✅ Encryption (KMS + EBS)
* ✅ Logging (Flow Logs + CloudWatch)
* ✅ Zero Trust Security Group
* ✅ Private EC2 (no public exposure)
* ✅ IMDSv2 (secure metadata)

---

# 🧠 One-Line Explanation:-

👉
**"This Terraform setup creates a secure AWS VPC with encrypted logging, restricted network access, IAM least privilege, and a hardened private EC2 instance following DevSecOps best practices."**

---

