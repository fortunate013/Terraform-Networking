# Project Overview

This project demonstrates the deployment of a multi-tier AWS network using Terraform. The infrastructure includes public and private subnet tiers, controlled routing, an Internet Gateway, and NAT-based outbound connectivity for private resources.

## Technologies Used

Terraform • AWS • AWS CLI • Visual Studio Code • Git • GitHub

## AWS Resources Created

- VPC
- Two public subnets
- Two private subnets
- Internet Gateway
- Elastic IP
- NAT Gateway
- Public route table
- Private route table
- Route-table associations

## AWS Terraform Networking

An example AWS network foundation managed with Terraform. It creates a VPC with public and private subnets, internet access for public resources, NAT-based outbound access for private resources, and an application security group.

> **Cost and security:** A NAT Gateway and its Elastic IP can incur AWS charges while deployed. The example security group allows SSH, HTTP, and HTTPS from `0.0.0.0/0`; restrict these rules before using the stack for real workloads. This is a learning foundation, not a production-ready architecture.

## Architecture

```text
AWS VPC — 10.0.0.0/16
│
├── Public Subnet A — 10.0.1.0/24
├── Public Subnet B — 10.0.2.0/24
│
├── Private Subnet A — 10.0.11.0/24
├── Private Subnet B — 10.0.12.0/24
│
├── Internet Gateway
├── Public Route Table
│      └── 0.0.0.0/0 -> Internet Gateway
│
├── NAT Gateway
└── Private Route Table
       └── 0.0.0.0/0 -> NAT Gateway
```

The configuration creates:

- One VPC with CIDR `10.0.0.0/16`, DNS support, and DNS hostnames enabled.
- Two public subnets: `10.0.1.0/24` and `10.0.2.0/24`.
- Two private subnets: `10.0.11.0/24` and `10.0.12.0/24`.
- An Internet Gateway attached to the VPC.
- A public route table that sends `0.0.0.0/0` traffic to the Internet Gateway. Both public subnets are associated with it and assign public IPv4 addresses on launch.
- One NAT Gateway in the first public subnet, with an Elastic IP.
- A private route table that sends `0.0.0.0/0` traffic to the NAT Gateway. Both private subnets are associated with it, allowing outbound internet access without assigning them public IP addresses.
- An application security group that allows inbound TCP ports 22, 80, and 443 from any IPv4 address, and allows all outbound traffic.

Subnet availability zones are selected from the zones AWS reports as available in the configured region.

## Network Design

- **Public tier:** The public subnets use a route table with a default route (`0.0.0.0/0`) to the Internet Gateway.
- **Private tier:** The private subnets have no direct route to the Internet Gateway; outbound traffic is routed through the NAT Gateway in a public subnet.

## Repository files

| File | Purpose |
| --- | --- |
| `main.tf` | Terraform and AWS provider requirements, provider configuration, and network resources |
| `.terraform.lock.hcl` | Locks the selected provider versions for repeatable initialization |
| `variable.tf` | AWS region and project tag-prefix inputs |
| `variables.tf` | Environment, VPC CIDR, and subnet CIDR inputs |
| `terraform.tfvars` | Values for this deployment, including the AWS region and network CIDRs |
| `outputs.tf` | VPC, subnet, gateway, route table, and security group IDs |
| `.gitignore` | Excludes Terraform working files, state files, plans, and override files |

The resource tags use `var.project` (default `mzu-day10` in `variable.tf`). `project_name` is a separately declared legacy input and does not set those tags.

## Prerequisites

- Terraform `>= 1.5.0`
- AWS credentials configured locally, for example through an AWS CLI profile or environment variables
- AWS permissions to create VPC, subnet, route table, Internet Gateway, Elastic IP, NAT Gateway, and security group resources

Do not put AWS access keys or other credentials in this repository.

## Terraform Workflow

Run these commands from the repository directory. Terraform reads `terraform.tfvars` automatically; review plans before applying them.

```text
terraform init
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
terraform output
terraform state list
terraform destroy
```

`terraform plan -out=tfplan` saves the execution plan, and `terraform apply tfplan` applies that saved plan. `terraform output` displays the exported resource IDs, while `terraform state list` lists resources tracked in the current state. Review the destroy plan before confirming; removing the NAT Gateway promptly after testing helps avoid ongoing charges.

## Evidence (embedded screenshots)

![Terraform Validation](screenshots/02-final-validation.png)
![Terraform Plan](screenshots/03-terraform-plan.png)
![Terraform Apply](screenshots/04-terraform-apply.png)
![AWS VPC](screenshots/07-vpc.png)
![AWS Subnets](screenshots/08-subnets.png)
![Public Route Table](screenshots/09-public-route-table.png)
![Private Route Table](screenshots/10-private-route-table.png)
![NAT Gateway](screenshots/11-nat-gateway.png)

## Key Learning Outcomes

Infrastructure as Code • AWS VPC design • CIDR planning • public and private subnet design • Internet Gateway routing • NAT Gateway routing • Terraform resource dependencies • state inspection • infrastructure validation • infrastructure documentation

## Security Notes

No AWS credentials or secrets are stored in this repository. Terraform state files and local Terraform working directories are excluded from Git.

## Cleanup

To remove the infrastructure created by this project, review the plan and run:

```sh
terraform destroy
```

## Author

Cloud Engineering Student — MZ-UCA Cloud Academy

## GitHub repository example

- **Suggested repository name:** `aws-terraform-networking`
- **Suggested description:** `Terraform example for an AWS VPC with public and private subnets, Internet Gateway, NAT Gateway, route tables, and application security group.`

After creating an empty repository on GitHub, initialize and publish this project from its folder:

```sh
git init
git add README.md .gitignore .terraform.lock.hcl *.tf terraform.tfvars
git commit -m "Add Terraform AWS networking stack"
git branch -M main
git remote add origin https://github.com/<your-username>/aws-terraform-networking.git
git push -u origin main
```

Check staged files before committing. The example `terraform.tfvars` contains only configuration values; keep credentials and other secrets out of it. Do not commit Terraform state files, plans containing sensitive values, or credentials.
