# Step 1 – Prepare the Resume Website

## Overview

Before deploying the AWS Resume Platform, I customized the frontend website by updating the HTML, CSS, and JavaScript files with my personal information, projects, certifications, and cloud engineering experience.

## Objectives

* Customize the resume website template
* Add personal branding and professional information
* Add AWS Cloud and DevOps projects
* Add architecture diagrams and images
* Add downloadable PDF resume
* Verify the website loads locally before deployment

---

## Project Structure

```text
website/
│
├── index.html
├── style.css
├── index.js
│
├── assets/
│   ├── banner.png
│   ├── avatar-alt.jpg
│   └── Nathan_Ambroise_Resume.pdf
│
├── img/
│   └── Aws-arch-cloud-resume.png
│
└── vendor/
    └── typed/
        └── typed.min.js
```

---

## Key Modifications

### Updated Personal Information

```html
<h1>Nathan Ambroise</h1>
```

### Updated Professional Title

```html
AWS Cloud Engineer / DevOps Engineer
```

### Added Resume Download

```html
<a href="./assets/Nathan_Ambroise_Resume.pdf"
   target="_blank"
   class="btn btn-dark text-uppercase">

   Download Resume

</a>
```

### Added Architecture Diagram

```html
<img src="./img/Aws-arch-cloud-resume.png"
     alt="AWS Resume Platform Architecture"
     class="img-fluid">
```

---

## Local Testing

Before deploying to AWS, the website was tested locally to verify:

* Images load correctly
* Resume PDF downloads correctly
* Navigation links work
* CSS styling renders properly
* JavaScript functions execute successfully

---

## Screenshot

Insert screenshot here:

```text
Screenshot 1 – Local Website Preview
```

![Local Website Preview](images/step1-local-preview.png)

---

## Outcome

The AWS Resume Platform frontend was successfully customized and verified locally. The website is now ready for deployment to Amazon S3.

```
```
# Step 2 – Create and Configure the Amazon S3 Bucket

## Overview

In this step, I created an Amazon S3 bucket to store and host the static files for my AWS Resume Platform. The bucket serves as the origin storage location for the website's HTML, CSS, JavaScript, images, and resume PDF files.

## Objectives

* Create an Amazon S3 bucket
* Configure bucket settings
* Upload website files
* Prepare the bucket for CloudFront integration
* Keep public access blocked for security

---

## Create the S3 Bucket

Navigate to:

```text
AWS Console
→ S3
→ Create Bucket
```

Configure the bucket:

| Setting             | Value                                  |
| ------------------- | -------------------------------------- |
| Bucket Name         | platform.nathan-resume.com             |
| AWS Region          | us-east-1                              |
| Object Ownership    | ACLs Disabled                          |
| Block Public Access | Enabled                                |
| Versioning          | Disabled                               |
| Encryption          | Amazon S3 Managed Keys (SSE-S3)        |

---

## Upload Website Files

After creating the bucket:

```text
Open Bucket
→ Upload
→ Add Files
```

Upload:

```text
website/
│
├── index.html
├── style.css
├── index.js
│
├── assets/
│   ├── banner.png
│   ├── avatar-alt.jpg
│   └── Nathan_Ambroise_Resume.pdf
│
├── img/
│   └── Aws-arch-cloud-resume.png
```

Click:

```text
Upload
```

---

## Verify Files

After upload, verify the bucket contains:

```text
index.html
style.css
index.js
assets/
img/
```

---

## Security Configuration

Public access remained blocked.

```text
Block Public Access = Enabled
```

The website will later be accessed securely through CloudFront instead of exposing the bucket directly.

---

## Screenshot

Insert screenshot here:

```text
Screenshot 2 – Amazon S3 Bucket Configuration
```

![S3 Bucket](images/step2-s3-bucket.png)

Insert screenshot here:

```text
Screenshot 3 – Website Files Uploaded to S3
```

![S3 Upload](images/step2-s3-upload.png)

---

## Outcome

The Amazon S3 bucket was successfully created and configured to store all static website assets for the AWS Resume Platform. The bucket is secured with public access blocked and is ready to be connected to CloudFront in the next step.

```
```
# Step 3 – Create the CloudFront Distribution

## Overview

In this step, I created an Amazon CloudFront distribution to securely deliver my AWS Resume Platform to users over HTTPS. CloudFront acts as a Content Delivery Network (CDN) and allows the website to be accessed globally while keeping the S3 bucket private.

## Objectives

* Create a CloudFront distribution
* Connect CloudFront to the S3 bucket
* Configure Origin Access Control (OAC)
* Keep the S3 bucket private
* Enable HTTPS-only access
* Configure the default root object

---

## Create the CloudFront Distribution

Navigate to:

```text
AWS Console
→ CloudFront
→ Create Distribution
```

### Origin Configuration

Select:

```text
Origin Domain
→ Your S3 Bucket
```

Example:

```text
platfrom.nathan-resume.com
```

---

## Configure Origin Access Control (OAC)

Create a new OAC:

```text
Origin Access Control
→ Create New OAC
```

Purpose:

```text
Allow CloudFront to access the S3 bucket
while keeping the bucket private.
```

---

## Update Bucket Policy

CloudFront will generate a bucket policy.

Navigate to:

```text
S3
→ Bucket
→ Permissions
→ Bucket Policy
```

Paste the generated policy.


```json
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::platform.nathan-resume.com/*",
            "Condition": {
                "ArnLike": {
                    "AWS:SourceArn": "arn:aws:cloudfront::461535892183:distribution/E16R376OTASJCW"
                }
            }
        }
    ]
}
```

---

## Configure Distribution Settings

### Viewer Protocol Policy

Select:

```text
Redirect HTTP to HTTPS
```

This forces encrypted traffic.

### Default Root Object

Set:

```text
index.html
```

This ensures users automatically load the homepage.

---

## Create Distribution

Click:

```text
Create Distribution
```

CloudFront will begin deployment.

Deployment may take several minutes.

---

## Verification

After deployment:

Copy the CloudFront domain name.

Example:

```text
d123abc456.cloudfront.net
```

Open it in a browser.

The website should load successfully.

---

## Screenshot

Insert screenshot here:

```text
Screenshot 4 – CloudFront Distribution Configuration
```

![CloudFront Configuration](images/step3-cloudfront-config.png)

Insert screenshot here:

```text
Screenshot 5 – Origin Access Control (OAC)
```

![OAC Configuration](images/step3-oac.png)

Insert screenshot here:

```text
Screenshot 6 – Website Loaded Through CloudFront
```

![CloudFront Website](images/step3-cloudfront-site.png)

---

## Outcome

Amazon CloudFront was successfully configured as the content delivery layer for the AWS Resume Platform. The S3 bucket remains private while CloudFront securely delivers the website globally over HTTPS.

```
```
# Step 4 – Request an SSL Certificate with AWS Certificate Manager (ACM)

## Overview

In this step, I requested a public SSL/TLS certificate using AWS Certificate Manager (ACM). The certificate allows my AWS Resume Platform to use HTTPS encryption and provides secure communication between users and the website.

## Objectives

* Request a public SSL certificate
* Validate domain ownership
* Prepare CloudFront for HTTPS
* Enable secure communication using TLS

---

## Open AWS Certificate Manager

Navigate to:

```text
AWS Console
→ Certificate Manager (ACM)
→ Request Certificate
```

Select:

```text
Request a Public Certificate
```

Click:

```text
Next
```

---

## Add Domain Name

Enter:

```text
*.nathan-resume.com
```

Using a wildcard certificate allows the certificate to be used for multiple subdomains.


```text
_5a2003f79ce5fa60a0a8885547ddb2b2.nathan-resume.com

```

---

## Validation Method

Select:

```text
DNS Validation
```

DNS validation is recommended because ACM can automatically renew the certificate.

---

## Add Tags 

```text
Key: Project
Value: AWS Resume Platform
```

---

## Request Certificate

Click:

```text
Request
```

The certificate status will initially show:

```text
Pending Validation
```

---

## Validate Ownership

ACM generates DNS validation records.

Navigate to:

```text
Route 53
→ Hosted Zone
→ nathan-resume.com
```

Create the CNAME records provided by ACM.

Example:

```text
Name:
_5a2003f79ce5fa60a0a8885547ddb2b2.nathan-resume.com
value:
_1addd76d86982fbb496215ccd71b141f.jkddzztszm.acm-validations.aws.

```

---

## Wait for Validation

After DNS propagation:

```text
Status:
Issued
```

The certificate is now available for CloudFront.

---

## Screenshot

Insert screenshot here:

```text
Screenshot 7 – ACM Certificate Request
```

![ACM Request](images/step4-acm-request.png)

Insert screenshot here:

```text
Screenshot 8 – DNS Validation Records
```

![DNS Validation](images/step4-acm-dns-validation.png)

Insert screenshot here:

```text
Screenshot 9 – Certificate Issued
```

![Certificate Issued](images/step4-acm-issued.png)

---

## Outcome

An SSL/TLS certificate was successfully issued using AWS Certificate Manager. This certificate will be attached to CloudFront to provide secure HTTPS access to platform.nathan-resume.com.

```
```
# Step 5 – Configure Route 53 Custom Domain

## Overview

In this step, I configured Amazon Route 53 to point my custom subdomain, `platform.nathan-resume.com`, to my CloudFront distribution.

## Objectives

* Use my purchased domain `nathan-resume.com`
* Create a DNS record for `platform.nathan-resume.com`
* Point the subdomain to CloudFront
* Verify the website loads from the custom domain

---

## Open Route 53

Navigate to:

```text
AWS Console
→ Route 53
→ Hosted Zones
→ nathan-resume.com
```

---

## Create DNS Record

Click:

```text
Create Record
```

Configure the record:

| Setting          | Value                            |
| ---------------- | -------------------------------- |
| Record name      | platform                         |
| Record type      | A                                |
| Alias            | Yes                              |
| Route traffic to | Alias to CloudFront distribution |
| Distribution     | Your CloudFront distribution     |
| Routing policy   | Simple                           |

Click:

```text
Create Records
```

---

## Verify Custom Domain

After DNS propagation, open:

```text
https://platform.nathan-resume.com
```

The AWS Resume Platform should load through CloudFront using HTTPS.

---

## Screenshot

Add screenshot here:

```text
Screenshot 10 – Route 53 A Record for platform.nathan-resume.com
```

![Cloudfront-CName ](images/step5-cloudfront-cname.png)
![Route 53 Record](images/step5-route53-record.png)

Add screenshot here:

```text
Screenshot 11 – Website Loading from Custom Domain
```

![Custom Domain Website](images/step5-custom-domain.png)

---

## Outcome

The custom domain `platform.nathan-resume.com` was successfully connected to the CloudFront distribution, allowing users to access the AWS Resume Platform through a professional HTTPS domain.

```
```
# Step 6 – Test the DynamoDB Visitor Counter Table

## Overview

Before deploying infrastructure with Terraform, I created a test DynamoDB table in the AWS Console to validate the visitor counter design and data structure.

## Objectives

* Validate the visitor counter database design
* Test DynamoDB table creation
* Create a sample visitor counter record
* Verify the table structure before Terraform deployment

> **Note:** This DynamoDB table was created for testing purposes. The production DynamoDB table is deployed later using Terraform.

---

## Create the Test Table

Navigate to:

```text
AWS Console
→ DynamoDB
→ Tables
→ Create Table
```

Configure:

| Setting       | Value                       |
| ------------- | --------------------------- |
| Table Name    | platform-nathan-resume-test |
| Partition Key | id                          |
| Key Type      | String                      |
| Capacity Mode | On-Demand                   |

---

## Create Initial Visitor Counter Record

Navigate to:

```text
Table
→ Explore Table Items
→ Create Item
```

Create:

```json
{
  "id": "1",
  "views": 1
}
```

---

## Verify Data Structure

The table should contain:

| id | views |
| -- | ----- |
| 1  | 1     |

This structure will later be used by the Lambda function to retrieve and update the visitor count.

---

## Screenshot

```text
Screenshot 12 – DynamoDB Test Table
```

![DynamoDB Table](images/step6-dynamodb-table.png)

```text
Screenshot 13 – DynamoDB Test Record
```

![DynamoDB Record](images/step6-dynamodb-item.png)

---

## Outcome

A DynamoDB test table was successfully created and validated. This confirmed the database design required for the visitor counter before automating deployment through Terraform.

```
```
# Step 7 – Test the Lambda Visitor Counter Function

## Overview

Before deploying the production Lambda function with Terraform, I created a test Lambda function in AWS to validate the visitor counter logic and verify communication with DynamoDB.

## Objectives

* Create a test Lambda function
* Connect Lambda to DynamoDB
* Retrieve the visitor count
* Increment the count by one
* Update DynamoDB automatically
* Return the updated count

> **Note:** This Lambda function was created for testing and validation. The production Lambda function is later deployed using Terraform.

---

## Create Lambda Function

Navigate to:

```text
AWS Console
→ Lambda
→ Create Function
```

Configure:

| Setting       | Value                       |
| ------------- | --------------------------- |
| Function Name | myfunc-test                 |
| Runtime       | Python 3.10                 |
| Architecture  | x86_64                      |
| Permissions   | Create New IAM Role         |

---

## Enable Function URL

Under Advanced Settings:

```text
Enable Function URL = Enabled
Authentication Type = NONE
```

This generates a public HTTPS endpoint used for testing.

---

## Lambda Test Code

```python
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('nathan-resume-platform-test')

def lambda_handler(event, context):

    response = table.get_item(
        Key={
            'id': '1'
        }
    )

    views = response['Item']['views']
    views = views + 1

    table.put_item(
        Item={
            'id': '1',
            'views': views
        }
    )

    return views
```

---

## Deploy and Test

Click:

```text
Deploy
```

Open the Function URL.

```
https://v62m4nlkzpcgiaqmifz35xfsoy0rlsbg.lambda-url.us-east-1.on.aws/ 
```

Expected result:

```text

```

Refreshing the page should increase the count.

---

## Validate DynamoDB Update

Return to DynamoDB and verify that the `views` attribute increases after each Lambda invocation.

```text
Before: 3
After: 4
```

---

## Screenshot

```text
Screenshot 14 – Lambda Function Configuration
```

![Lambda Configuration](images/step7-lambda-config.png)

```text
Screenshot 15 – Lambda Function URL Test
```

![Lambda URL Test](images/step7-lambda-url.png)

```text
Screenshot 16 – DynamoDB Updated by Lambda
```

![Lambda DynamoDB Update](images/step7-lambda-update.png)

---

## Outcome

A test Lambda function successfully retrieved visitor counts from DynamoDB, incremented the count, updated the database, and returned the new value. This validated the visitor counter logic before automating deployment with Terraform.

```
```
# Step 8 – Test the JavaScript Visitor Counter Integration

## Overview

After validating the DynamoDB table and Lambda function, I connected the frontend website to the backend API using JavaScript. This allows the AWS Resume Platform to retrieve and display the live visitor count directly on the website.

## Objectives

* Create a JavaScript visitor counter
* Connect the website to the Lambda Function URL
* Retrieve visitor counts dynamically
* Display the count on the website
* Validate frontend and backend communication

> **Note:** This step was completed using a test Lambda Function URL before deploying the production infrastructure with Terraform.

---

## Create the Visitor Counter Element

Inside `index.html`, I added counter elements using the `counter-number` class.

```html
<div class="counter-number">
    Loading Views...
</div>
```

The same class can be used in multiple sections, such as:

```text
Navigation Menu
Visitor Counter Section
Footer
```

---

## Initial JavaScript Attempt

The first JavaScript implementation attempted to call the Lambda Function URL and parse the response as JSON.

```javascript
const counterElements = document.querySelectorAll(".counter-number");

async function updateCounter() {
    try {
        const response = await fetch(
            "https://v62m4nlkzpcgiaqmifz35xfsoy0rlsbg.lambda-url.us-east-1.on.aws/"
        );

        const data = await response.json();

        counterElements.forEach(counter => {
            counter.innerHTML = `👀 Views: ${data}`;
        });

    } catch (error) {
        console.error("Visitor counter error:", error);

        counterElements.forEach(counter => {
            counter.innerHTML = "👀 Views: unavailable";
        });
    }
}

updateCounter();
```

This version did not display the visitor count correctly because the Lambda function returned a plain text value instead of JSON.

---

## Updated JavaScript Integration

The JavaScript was updated to use `response.text()` instead of `response.json()`.

```javascript
const counterElements = document.querySelectorAll(".counter-number");

async function updateCounter() {
    try {
        const response = await fetch(
            "https://v62m4nlkzpcgiaqmifz35xfsoy0rlsbg.lambda-url.us-east-1.on.aws/",
            {
                method: "GET"
            }
        );

        if (!response.ok) {
            throw new Error(`HTTP error: ${response.status}`);
        }

        const data = await response.text();

        counterElements.forEach(counter => {
            counter.innerHTML = `👀 Views: ${data}`;
        });

    } catch (error) {
        console.error("Visitor counter error:", error);

        counterElements.forEach(counter => {
            counter.innerHTML = "👀 Views: unavailable";
        });
    }
}

updateCounter();
```

---

## Verify HTML Integration

The website includes the `counter-number` class in multiple locations so all counters update at the same time.

Example:

```html
<h2 class="counter-number font-staat font-size-34">
    Loading Views...
</h2>
```

In JavaScript, the selector uses `.counter-number` because the period represents a CSS class selector.

```javascript
document.querySelectorAll(".counter-number");
```

---

## Test the Counter

After uploading the updated `index.js` file, I refreshed the website.

Expected result:

```text
👀 Views: 13
```

Each refresh should:

1. Call the Lambda Function URL
2. Retrieve the current visitor count
3. Increment the value in DynamoDB
4. Return the updated count
5. Display the updated count on the website

---

## Validate End-to-End Functionality

The full visitor counter workflow is:

```text
User visits website
      ↓
JavaScript sends fetch request
      ↓
Lambda Function URL is invoked
      ↓
Lambda updates DynamoDB
      ↓
Updated count is returned
      ↓
Website displays the visitor count
```

---

## Troubleshooting and Debugging

During implementation, the visitor counter initially displayed:

```text
👀 Views: unavailable
```

The following issues were reviewed and corrected.

### Issue 1 – Lambda Response Format

The original code expected a JSON response.

```javascript
const data = await response.json();
```

However, the Lambda function returned a plain text number. The JavaScript was updated to:

```javascript
const data = await response.text();
```

### Issue 2 – Lambda Function URL CORS

The Lambda Function URL required CORS settings so the browser could call it from the website domain.

Recommended production configuration:

```text
Allow Origin: https://platform.nathan-resume.com
Allow Methods: GET
Allow Headers: *
```

Temporary testing configuration:

```text
Allow Origin: *
Allow Methods: GET
Allow Headers: *
```

### Issue 3 – CloudFront Cache

After updating `index.js`, CloudFront may continue serving an older cached version of the file. To refresh the cache, I created a CloudFront invalidation.

```text
CloudFront
→ Distributions
→ Invalidations
→ Create Invalidation
```

Invalidation path:

```text
/*
```

### Issue 4 – Browser Developer Tools

I used browser developer tools to verify:

* JavaScript errors
* Failed network requests
* HTTP response status codes
* CORS errors
* Whether the updated `index.js` file loaded correctly

---

## Screenshot

```text
Screenshot 17 – JavaScript Visitor Counter Code
```

![JavaScript Counter](images/step8-javascript-code.png)

```text
Screenshot 18 – Visitor Counter Displayed on Website
```

![Website Counter](images/step8-visitor-counter.png)

```text
Screenshot 19 – CloudFront Cache Invalidation
```

![CloudFront Invalidation](images/step8-cloudfront-invalidation.png)

```text
Screenshot 20 – Visitor Counter Working
```

![Visitor Counter Working](images/step8-counter-working.png)

---

## Outcome

The frontend website was connected to the Lambda Function URL using JavaScript. After troubleshooting the Lambda response format, CORS settings, and CloudFront caching, the website successfully displayed the live visitor count from DynamoDB. This validated the end-to-end visitor counter workflow before deploying the production infrastructure with Terraform.
