# AWS Resume Platform – Step-by-Step Build Guide

## 1. Project Goal
Build a resume platform on AWS using serverless services, Terraform, and automated deployment.

## 2. Frontend Setup
- Built resume website using HTML, CSS, and JavaScript
- Stored website files in the `/website` folder

## 3. S3 Static Website Hosting
- Created S3 bucket with Terraform
- Uploaded frontend files
- Configured bucket for static website hosting

## 4. CloudFront CDN
- Created CloudFront distribution
- Connected CloudFront to S3 origin
- Improved performance and HTTPS delivery

## 5. Route 53 and Custom Domain
- Configured DNS records
- Pointed domain to CloudFront distribution

## 6. ACM Certificate
- Requested SSL/TLS certificate
- Validated certificate through DNS
- Attached certificate to CloudFront

## 7. DynamoDB Visitor Counter
- Created DynamoDB table
- Stored visitor count as backend data

## 8. Lambda Function
- Created Lambda function
- Connected Lambda to DynamoDB
- Updated visitor count when users visit the site

## 9. GitHub Actions CI/CD
- Created workflow for frontend deployment
- Automated updates to S3 and CloudFront

## 10. Terraform Infrastructure
- Used Terraform to create AWS resources
- Organized infrastructure code by service

## 11. Challenges and Fixes
- Add real problems you faced
- Add how you fixed them
- This section makes the project look more real

## 12. Final Result
The final platform is a cloud-hosted resume website with automated deployment, HTTPS, CDN delivery, and a serverless backend.