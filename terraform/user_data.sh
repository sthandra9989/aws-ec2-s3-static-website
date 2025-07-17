#!/bin/bash
apt update -y
apt install -y apache2 awscli

# Set variables passed from templatefile
S3_BUCKET="${s3_bucket}"
S3_IMAGE="${s3_image}"

# Fetch image from S3
aws s3 cp s3://$S3_BUCKET/$S3_IMAGE /var/www/html/$S3_IMAGE

# Create simple index.html referencing the image
echo "<html><body><h1>Welcome</h1><img src='$S3_IMAGE' style='max-width:100%;'></body></html>" > /var/www/html/index.html

# Start Apache
systemctl start apache2
systemctl enable apache2
