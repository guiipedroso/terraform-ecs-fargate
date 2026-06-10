# 🐳 ECS Fargate Infrastructure with Terraform

<div align="center">

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![ECS](https://img.shields.io/badge/Amazon%20ECS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Fargate](https://img.shields.io/badge/AWS%20Fargate-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Next.js](https://img.shields.io/badge/Next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white)

**Production-ready container infrastructure on AWS using Infrastructure as Code**

🌐 **Live demo running on AWS ECS Fargate**

[Architecture](#-architecture) • [Modules](#-modules) • [Tech Stack](#-tech-stack) • [Getting Started](#-getting-started) • [Project Structure](#-project-structure)

</div>

---

## 📋 Overview

This project provisions a **complete container infrastructure on AWS** using Terraform, following Infrastructure as Code best practices. It deploys a containerized application on **Amazon ECS with Fargate**, exposed via an **Application Load Balancer with HTTPS**, running on a secure VPC with public and private subnets.

The Terraform code is organized into reusable **modules**, making it easy to understand, maintain, and extend.

---

## 🎯 What It Solves

Running containers in production requires a well-structured cloud environment with:

- **Secure networking** — public and private subnets with controlled traffic flow
- **Scalable compute** — serverless containers that scale without managing EC2 instances
- **HTTPS enforcement** — valid SSL certificates and TLS termination at the load balancer
- **Least privilege access** — IAM roles scoped only to what the container actually needs
- **High availability** — resources distributed across multiple Availability Zones

---

## 🏗 Architecture

The infrastructure follows a layered design across two Availability Zones (`us-east-1a` and `us-east-1b`):

```
Internet
    │
    ▼
[ Route53 + ACM Certificate ]
    │  (DNS validation + HTTPS)
    ▼
[ Application Load Balancer ]  ← public subnets (1a, 1b)
    │  (port 443 → port 3000)
    ▼
[ ECS Fargate Service ]        ← private subnets (1a, 1b)
    │  (Next.js container: port 3000)
    ▼
[ NAT Gateway ]                ← outbound traffic (ECR pull, CloudWatch logs)
    │
    ▼
Internet
```

### Infrastructure Layers

#### 1. Network Layer
- **VPC** (`10.0.0.0/24`) with Internet Gateway
- **Public subnets** (`10.0.0.0/26`, `10.0.0.64/26`) — ALB and NAT Gateway
- **Private subnets** (`10.0.0.128/26`, `10.0.0.192/26`) — ECS tasks (no public IP)
- **NAT Gateway** — allows private subnets to reach the internet for outbound traffic

#### 2. Security Layer
- **ALB Security Group** — inbound HTTPS (443) from internet only
- **ECS Security Group** — inbound TCP (3000) from ALB only, full egress for ECR/CloudWatch
- **IAM Execution Role** — least privilege: `AmazonECSTaskExecutionRolePolicy` + `CloudWatchLogsFullAccess` + `AmazonEC2ContainerRegistryReadOnly`

#### 3. Load Balancer Layer
- **Application Load Balancer** — internet-facing, HTTPS listener on port 443
- **Target Group** — type `ip` (required for Fargate `awsvpc` network mode), port 3000
- **ACM Certificate** — covers the apex domain + wildcard (`*.yourdomain.com`) with DNS validation via Route53

#### 4. Container Layer
- **ECR Repository** — private registry for the Next.js Docker image
- **ECS Cluster** with Fargate capacity provider
- **Task Definition** — 1 vCPU, 2GB RAM, CloudWatch Logs integration, Next.js image from ECR
- **ECS Service** — desired count 1, running in private subnets, connected to ALB

---

## 📦 Modules

The project is structured into 5 independent Terraform modules:

| Module | Resources |
|---|---|
| `modules/network` | VPC, subnets, IGW, NAT Gateway, EIP, route tables |
| `modules/security` | Security groups (ALB + ECS), IAM execution role |
| `modules/acm` | ACM certificate, Route53 record, certificate validation |
| `modules/alb` | Application Load Balancer, target group, HTTPS listener |
| `modules/ecs` | ECR repository, ECS cluster, capacity provider, task definition, service |

Each module exposes outputs consumed by dependent modules through the root `main.tf`.

---

## 🛠 Tech Stack

| Category | Technology |
|---|---|
| **IaC** | Terraform |
| **Cloud Provider** | AWS |
| **Container Orchestration** | Amazon ECS (Fargate) |
| **Application** | Next.js 16 (containerized) |
| **Networking** | VPC, subnets, NAT Gateway, Internet Gateway |
| **Load Balancing** | Application Load Balancer (ALB) |
| **TLS/SSL** | AWS Certificate Manager (ACM) |
| **DNS** | Amazon Route53 |
| **Security** | IAM, Security Groups |
| **Observability** | Amazon CloudWatch Logs |
| **Container Registry** | Amazon ECR |

---

## 📁 Project Structure

```
ecs_project/
├── provider.tf                   # AWS provider configuration
├── main.tf                       # Root module — wires all modules together + Route53 alias records
├── portal/                       # Next.js application
│   ├── Dockerfile
│   ├── package.json
│   └── app/
│       ├── layout.tsx
│       └── page.tsx
└── modules/
    ├── network/
    │   ├── main.tf               # VPC, subnets, IGW, NAT, route tables
    │   └── outputs.tf            # vpc_id, subnet IDs
    ├── security/
    │   ├── main.tf               # Security groups (ALB + ECS) + IAM role
    │   ├── variables.tf
    │   └── outputs.tf            # sg IDs, execution role ARN
    ├── acm/
    │   ├── main.tf               # ACM certificate, Route53 CNAME validation
    │   └── outputs.tf            # certificate_arn, zone_id
    ├── alb/
    │   ├── main.tf               # ALB, target group (port 3000), HTTPS listener
    │   ├── variables.tf
    │   └── outputs.tf            # target_group_arn, alb_dns_name, alb_zone_id
    └── ecs/
        ├── main.tf               # ECR repo, cluster, task definition, service
        ├── variables.tf
        └── outputs.tf            # cluster_id
```

---

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured with credentials
- AWS account with permissions to create VPC, ECS, ALB, ACM, Route53, and IAM resources
- A hosted zone in Route53 for your domain

### Installation & Deploy

**1. Clone the repository**

```bash
git clone https://github.com/guiipedroso/ecs-fargate-terraform.git
cd ecs-fargate-terraform
```

**2. Configure AWS credentials**

```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, and Region (us-east-1)
```

**3. Set your domain and IAM Role in `terraform.tfvars`**

Copy the example file and fill in your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

```hcl
# terraform.tfvars
domain   = "yourdomain.com"
role_arn = "arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>"
```

> `terraform.tfvars` is listed in `.gitignore` — your sensitive values will never be committed. If you don't use `assume_role`, leave `role_arn` as an empty string `""` and Terraform will use your local AWS credentials.

**4. Initialize Terraform**

```bash
terraform init
```

**5. Preview and apply the infrastructure**

```bash
terraform plan
terraform apply
```

> The full provisioning takes approximately **3–5 minutes**, with the ACM certificate validation being the longest step.

**6. Build and push the Docker image to ECR**

After the infrastructure is up, get the ECR repository URL from the Terraform output and push the image:

```bash
# Authenticate with ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

# Build (linux/amd64 required for Fargate)
docker build --platform linux/amd64 -t guipedroso-ecs-portal ./portal

# Tag and push
docker tag guipedroso-ecs-portal:latest \
  <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/guipedroso-ecs-portal:latest

docker push \
  <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/guipedroso-ecs-portal:latest
```

**7. Force ECS to deploy the new image**

```bash
aws ecs update-service \
  --cluster guipedroso-ecs-cluster \
  --service guipedroso-ecs-portal-service \
  --force-new-deployment \
  --region us-east-1
```

The service will pull the new image and roll it out automatically.

### Destroy

To remove all provisioned resources:

```bash
terraform destroy
```

---

## 🔍 Key Implementation Highlights

### 1. Module Communication via Outputs

Each module exposes outputs that flow into dependent modules through the root `main.tf`:

```hcl
module "ecs" {
  source = "./modules/ecs"

  private_subnet_1a_id = module.network.private_subnet_1a_id
  ecs_sg_id            = module.security.ecs_sg_id
  execution_role_arn   = module.security.ecs_execution_role_arn
  target_group_arn     = module.alb.target_group_arn
}
```

### 2. Fargate with Private Subnets + NAT Gateway

ECS tasks run in **private subnets** (no public IP) and reach the internet via NAT Gateway. This is the production-recommended pattern: containers are never directly reachable from the internet.

```hcl
network_configuration {
  subnets          = [var.private_subnet_1a_id, var.private_subnet_1b_id]
  security_groups  = [var.ecs_sg_id]
  assign_public_ip = false
}
```

### 3. DNS-based Certificate Validation

The ACM certificate is automatically validated via Route53, with no manual intervention required:

```hcl
resource "aws_route53_record" "this" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  # ...
}
```

### 4. Least Privilege IAM

The ECS execution role follows the principle of least privilege — only the permissions the container actually needs:

| Policy | Purpose |
|---|---|
| `AmazonECSTaskExecutionRolePolicy` | Core ECS task execution |
| `CloudWatchLogsFullAccess` | Write container logs |
| `AmazonEC2ContainerRegistryReadOnly` | Pull images from ECR |

---

## 🎓 What I Learned

- Designing modular Terraform projects with clear separation of concerns
- AWS networking best practices (public vs private subnets, NAT Gateway patterns)
- Fargate networking requirements (`awsvpc` mode, `target_type = "ip"`)
- ACM certificate lifecycle and automated DNS validation with Route53
- IAM least privilege applied to ECS workloads
- Security group layering (ALB → ECS traffic flow)
- Dockerizing a Next.js app with multi-stage builds for production (`standalone` output)
- Managing ECR lifecycle: building, tagging, and pushing images for Fargate
- Debugging ECS task failures using CloudWatch Logs and `describe-services` events
- Resolving Terraform state conflicts (`create_before_destroy`, state `rm`, resource rename)

---

## 👨‍💻 About Me

**DevOps / Cloud Engineer | AWS Certified**

I'm passionate about cloud infrastructure, automation, and building reliable systems using Infrastructure as Code. This project showcases my ability to design and provision production-ready AWS environments with Terraform.

### 🏆 Certifications

- 2x AWS Certified

### 🔗 Connect with Me

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/gui-pedroso/)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/guiipedroso)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:pedroso.gui7@gmail.com)

---

<div align="center">

**If you found this project helpful, please consider giving it a ⭐!**

**Built with ❤️ by Guilherme Pedroso**

</div>
