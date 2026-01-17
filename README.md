# DevSecOps Infrastructure Automation Project

## Problem Statement
In many organisations, cloud infrastructure is provisioned manually using the AWS console or ad-hoc scripts. This approach introduces several risks:
- Inconsistent environments across deployments
- Security misconfigurations that are hard to detect
- Long-lived credentials embedded in pipelines or developer machines
- No clear audit trail of infrastructure changes
- Resources left running unnecessarily, increasing cost

This project addresses these challenges by implementing a secure, automated, and repeatable infrastructure provisioning workflow using DevSecOps principles.

---

## Solution Overview
This project implements a DevSecOps pipeline that automates the provisioning and teardown of AWS infrastructure using Infrastructure as Code (Terraform) and CI/CD automation with GitHub Actions.

Security is embedded directly into the pipeline through automated scanning, and infrastructure changes are fully auditable through version-controlled code and CI/CD logs.

---

## Key Features

### CI/CD-Driven Infrastructure Lifecycle
- GitHub Actions automates `terraform plan`, `apply`, and `destroy`
- Eliminates manual cloud console interaction
- Ensures consistent and repeatable deployments

### Embedded Security Controls
- Automated security scanning using **Tfsec** and **Checkov**
- Focus on identifying high-risk misconfigurations, particularly for EC2 and RDS
- Security issues are detected early in the deployment lifecycle

### Remote Terraform State Management
- Terraform state stored remotely in an **AWS S3 bucket**
- Enables safe updates and teardown via CI/CD
- Prevents state conflicts and supports collaboration

---

## Architecture Overview
The pipeline follows this flow:
1. Code changes are pushed to GitHub
2. GitHub Actions triggers the CI/CD workflow
3. Terraform provisions or destroys AWS infrastructure
4. Security tools scan infrastructure definitions before deployment
5. State is securely stored in S3 for consistency and auditability

---

## Tools and Technologies
- **Terraform** – Infrastructure as Code (IaC)
- **GitHub Actions** – CI/CD automation
- **AWS S3** – Remote Terraform state storage
- **AWS EC2** – Compute resources
- **AWS RDS** – Managed relational database
- **Tfsec & Checkov** – Infrastructure security scanning

---

## What This Project Demonstrates
- Secure cloud infrastructure automation
- DevSecOps best practices
- CI/CD-driven infrastructure lifecycle management
- Security-first infrastructure design
- Real-world cloud engineering workflows
