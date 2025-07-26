# Static Website Hosting on AWS S3

This project contains Terraform configurations to set up static website hosting using Amazon S3. It creates a publicly accessible S3 bucket configured for website hosting with all necessary permissions and configurations.

## Prerequisites

1. [AWS Account](https://aws.amazon.com/)
2. [AWS CLI](https://aws.amazon.com/cli/) installed and configured
3. [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0 or newer)

## Infrastructure Components

- S3 Bucket configured for static website hosting
- Bucket policy for public read access
- Website configuration with index and error documents
- Automatic file upload with correct MIME types

## Step-by-Step Setup Instructions

### 1. AWS Configuration
```bash
# Install AWS CLI (if not already installed)
# Windows: Download and run the AWS CLI MSI installer
# macOS/Linux:
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Configure AWS CLI
aws configure
# Enter your:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region (e.g., us-east-1)
# - Output format (json)
```

### 2. Prepare Website Files
1. Create website directory structure:
```bash
cd s3
mkdir -p website
cd website
```

2. Create basic website files:

**index.html**:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My S3 Static Website</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Welcome to My S3 Static Website</h1>
        <p>This website is hosted on Amazon S3!</p>
        <img src="images/logo.png" alt="Logo">
    </div>
</body>
</html>
```

**error.html**:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Page Not Found</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>404 - Page Not Found</h1>
        <p>The page you're looking for doesn't exist.</p>
        <a href="/">Go back home</a>
    </div>
</body>
</html>
```

**styles.css**:
```css
body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    margin: 0;
    padding: 20px;
    background-color: #f4f4f4;
}
.container {
    max-width: 800px;
    margin: 0 auto;
    background-color: white;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}
h1 {
    color: #333;
    text-align: center;
}
img {
    max-width: 100%;
    height: auto;
    display: block;
    margin: 20px auto;
}
```

3. Create images directory:
```bash
mkdir images
# Add your images to the images directory
```

### 3. Configure Terraform

1. Create a `terraform.tfvars` file:
```bash
cd ../terraform
```

Create `terraform.tfvars` with your bucket name:
```hcl
bucket_name = "your-unique-bucket-name"  # Must be globally unique
aws_region  = "us-east-1"               # Your preferred region
environment = "dev"                     # Environment tag
```

### 4. Deploy Infrastructure

1. Initialize Terraform:
```bash
terraform init
```

2. Review the plan:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply -auto-approve
```

4. After successful deployment, Terraform will output:
- Website endpoint URL
- S3 bucket domain name
- Direct website URL

### 5. Access Your Website

Open your browser and visit the website URL from the Terraform output:
```
http://<bucket-name>.s3-website-<region>.amazonaws.com
```

## Customizing the Website

1. **Local Development**:
   - Modify files in the `website` directory
   - Test locally using a web browser
   - Run `terraform apply` to upload changes

2. **File Organization**:
   ```
   website/
   ├── index.html
   ├── error.html
   ├── styles.css
   ├── js/
   │   └── script.js
   └── images/
       ├── logo.png
       └── other-images.jpg
   ```

## Security Considerations

1. **Bucket Access**:
   - The bucket is configured for public read access
   - Only upload files that should be publicly accessible
   - Consider using CloudFront for additional security

2. **Best Practices**:
   - Enable bucket versioning for file history
   - Set up logging for access tracking
   - Use HTTPS with CloudFront
   - Regularly review bucket policies

## Clean Up

To avoid ongoing charges, destroy the infrastructure when not needed:
```bash
terraform destroy -auto-approve
```

## Troubleshooting

1. **Bucket Creation Fails**:
   - Ensure bucket name is globally unique
   - Check AWS credentials
   - Verify region settings

2. **Website Not Accessible**:
   - Verify bucket policy is applied
   - Check file permissions
   - Ensure index.html exists
   - Confirm website hosting is enabled

3. **File Upload Issues**:
   - Check file paths in website directory
   - Verify file permissions
   - Ensure MIME types are correctly mapped

4. **Terraform Errors**:
   - Run `terraform fmt` to format files
   - Use `terraform validate` to check configuration
   - Check AWS provider version compatibility

## Additional Features

To enhance your static website, consider:

1. **Custom Domain**:
   - Register domain in Route 53
   - Create SSL certificate
   - Set up CloudFront distribution

2. **Performance**:
   - Enable compression
   - Set up caching headers
   - Optimize images

3. **Monitoring**:
   - Enable access logging
   - Set up CloudWatch metrics
   - Monitor error rates 