# Week 4: Secure Public Website with Private Infrastructure

AWS Cloud Engineering Bootcamp - Final Project

## Project Overview

This project deploys a production-grade, secure cloud architecture for a European logistics company migrating their public website to AWS. The architecture separates public-facing resources from private administrative systems using defense-in-depth security principles.

📊 **[View Capstone Presentation](./docs/Cloud-Bootcamp-Capstone-Presentation-Secure-Cloud-Infrastructure.pdf)**

## Architecture Diagrams

**Project Template:**
![Project Template](./diagrams/INTERNET.png)

**Implemented Architecture:**
![Architecture Diagram](./diagrams/architecture-diagram.png)

## Architecture

- **Public Tier**: Apache web server in public subnet serving customer-facing website
- **Private Tier**: Admin server in private subnet with no internet access
- **Static Assets**: S3 bucket for website images
- **Access Control**: IAM role-based access via AWS Systems Manager
- **Networking**: VPC with public/private subnets, Internet Gateway, and NAT Gateway

## Website Screenshot

![Website Screenshot](./diagrams/CloudWebsite.png)

*Note: Infrastructure was deployed and tested successfully, then torn down to avoid ongoing costs.*

## Technologies Used

- **Infrastructure as Code**: Terraform
- **Cloud Provider**: AWS (us-east-2)
- **Web Server**: Apache HTTP Server
- **Version Control**: Git/GitHub
- **Remote State**: S3 + DynamoDB

## Security Features

- Network segmentation (public/private subnets)
- No SSH ports exposed to internet (SSM access only)
- IAM role-based access control
- Break-glass emergency access (single IP)
- NAT Gateway for outbound-only private server updates
- Encrypted remote state storage

## Deployed Resources

- VPC with CIDR 10.0.0.0/16
- 2 subnets (1 public, 1 private)
- 2 EC2 instances (t3.micro)
- NAT Gateway
- Internet Gateway
- S3 bucket for static assets
- DynamoDB table for state locking

## Project Structure
```
├── docs/           # Project documentation and presentations
├── diagrams/       # Architecture diagrams and screenshots
├── terraform/      # Infrastructure as Code files
└── README.md
```

## Team

- Jay Twitty and Chadwick James

## Project Date

February 2026
