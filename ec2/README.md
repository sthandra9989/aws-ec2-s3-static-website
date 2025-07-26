# Static Website Hosting on AWS EC2

This project contains Terraform configurations to set up a static website hosting infrastructure on AWS EC2. The infrastructure includes a VPC, public subnet, security group, and an EC2 instance running Apache web server.

## Prerequisites

1. [AWS Account](https://aws.amazon.com/)
2. [AWS CLI](https://aws.amazon.com/cli/) installed and configured
3. [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0 or newer)
4. Basic understanding of HTML/CSS for website customization

## Infrastructure Components

- VPC with public subnet
- Internet Gateway
- Route Table
- Security Group (allowing HTTP, HTTPS, and SSH)
- EC2 instance (Amazon Linux 2023)
- Elastic IP
- Apache Web Server

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

### 2. Terraform Setup
```bash
# Clone this repository (if you haven't already)
git clone <repository-url>
cd ec2

# Create SSH key pair in the terraform directory
cd terraform
ssh-keygen -t rsa -b 2048 -f ssh_key
# This will create:
# - ssh_key (private key)
# - ssh_key.pub (public key)
```

### 3. Configure Variables
1. Find your IP address:
   ```bash
   # Windows
   curl ifconfig.me
   # Linux/macOS
   curl ifconfig.me
   ```

2. Update `variables.tf`:
   ```hcl
   variable "my_ip" {
     default = "YOUR_IP/32"  # Replace YOUR_IP with the IP from step 1
   }
   ```

### 4. Prepare Website Files
1. Create your static website files in a directory called `website`:
   ```bash
   mkdir website
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
       <title>My Website</title>
       <link rel="stylesheet" href="styles.css">
   </head>
   <body>
       <div class="container">
           <h1>Welcome to My Website</h1>
           <p>This is my awesome static website hosted on AWS EC2!</p>
           <img src="images/logo.png" alt="Logo">
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
   ```

3. Create an `images` directory for your images:
   ```bash
   mkdir images
   # Add your images to this directory
   ```

### 5. Deploy Infrastructure
```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply -auto-approve
```

### 6. Upload Website Files
After the infrastructure is deployed, you'll get the EC2 instance's public IP. Use it to upload your website files:

```bash
# Copy website files to EC2 instance
scp -i ssh_key -r website/* ec2-user@<public_ip>:/tmp/
ssh -i ssh_key ec2-user@<public_ip>

# On the EC2 instance:
sudo cp -r /tmp/* /var/www/html/
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html
```

### 7. Access Your Website
- Open your browser and visit: `http://<public_ip>`
- Your website should now be live!

## Customizing the Website

1. **Local Development**:
   - Modify files in your `website` directory
   - Test locally using a web browser
   - Once satisfied, upload to EC2 using the scp command above

2. **Direct Server Editing**:
   ```bash
   # SSH into the server
   ssh -i ssh_key ec2-user@<public_ip>
   
   # Edit files directly
   sudo nano /var/www/html/index.html
   sudo nano /var/www/html/styles.css
   ```

## Security Considerations

1. The security group is configured to allow:
   - HTTP (80) from anywhere
   - HTTPS (443) from anywhere
   - SSH (22) from your IP only

2. Make sure to:
   - Keep your SSH private key secure
   - Regularly update the security group rules
   - Consider adding SSL/TLS for HTTPS
   - Regularly update the EC2 instance

## Clean Up

To avoid ongoing charges, destroy the infrastructure when not needed:
```bash
terraform destroy -auto-approve
```

## Troubleshooting

1. **Cannot SSH into Instance**
   - Verify your IP address in `variables.tf`
   - Check security group rules
   - Ensure you're using the correct key pair
   - Try: `ssh -i ssh_key -v ec2-user@<public_ip>` for verbose output

2. **Website Not Accessible**
   - Check Apache status: `sudo systemctl status httpd`
   - Verify security group allows port 80
   - Check file permissions: `ls -la /var/www/html/`
   - Check Apache logs: `sudo tail -f /var/log/httpd/error_log`

3. **Terraform Errors**
   - Ensure AWS credentials are properly configured
   - Check for syntax errors in .tf files
   - Verify AWS region and availability zone settings
   - Run `terraform fmt` to format files
   - Run `terraform validate` to check for configuration errors 