# DevSecOps Project

This project implements a DevSecOps pipeline using Terraform, GitHub Actions, and AWS services including S3, EC2, and RDS.

## Features 

CI/CD Pipeline with GitHub Actions
Automates the provisioning and teardown of infrastructure using Terraform.

Security Scanning
Integrated automated security tools such as Tfsec and Checkov to identify high-risk security issues, especially around EC2 and RDS configurations.

Remote Terraform State Management
An S3 bucket was created to store the Terraform state file, enabling consistent and collaborative infrastructure management. This also ensures that resources can be safely destroyed or updated through GitHub Actions.

## Tools and Technologies 

Terraform – Infrastructure as Code (IaC)

AWS S3 – Remote state storage

AWS EC2 – Compute resource

AWS RDS – Managed relational database

GitHub Actions – CI/CD automation

Tfsec & Checkov – Security scanning