#  Hosting a Static Website with EC2 and S3

# Clone Repo
```
git clone https://github.com/atulkamble/aws-ec2-s3-static-website.git
cd aws-ec2-s3-static-website
```


### **Steps and Codes**

1. **Launch EC2 and Connect it using SSH**
   - **Launch EC2 Instance:** Follow the standard AWS EC2 launch process from the AWS Management Console.
   - **Connect to EC2 Instance:**
     ```bash
     ssh -i /path/to/your-key-pair.pem ec2-user@your-ec2-public-dns
     ```

2. **Install Webserver into EC2 Instance**
   ```bash
   sudo yum update -y
   sudo yum install git -y
   git --version
   git config --global user.name "username"
   git config --global user.email "email-id"
   sudo yum install httpd -y
   sudo systemctl start httpd
   sudo systemctl enable httpd
   sudo systemctl status httpd
   sudo usermod -a -G apache ec2-user
   sudo chmod 755 /var/www/html
   pwd
   cd /var/www/html
   pwd
   ls
   sudo touch index.html
   sudo nano index.html
   ```

3. **Create an S3 Bucket**
   - **AWS Management Console:** Navigate to S3 service, and click “Create bucket”. Follow the prompts to set up your bucket.

4. **Apply Bucket Policy**
   - **Note Down ARN of Bucket:** Replace `your-bucket-name` with your actual bucket name.
   - **Bucket Policy:**
     ```json
     {
         "Version": "2012-10-17",
         "Statement": [
             {
                 "Sid": "PublicReadGetObject",
                 "Effect": "Allow",
                 "Principal": "*",
                 "Action": "s3:GetObject",
                 "Resource": "arn:aws:s3:::your-bucket-name/*"
             }
         ]
     }
     ```
   - **Alternatively, Generate Policy:** Use the AWS Policy Generator or create a custom policy for your needs.

5. **Upload `Coffee.img` to S3 Bucket**
   - **AWS Management Console:** Navigate to your bucket, click “Upload”, and select `Coffee.img`.

6. **Copy URL of Uploaded Image**
   - **Retrieve URL:** Find the URL of the uploaded image from the S3 bucket’s object details.

7. **Paste URL in `index.html`**
   - **Update `index.html`:** Add an image tag with the S3 URL in your `index.html` file.
     ```html
     <html>
     <head>
         <title>My Static Website</title>
     </head>
     <body>
         <h1>Welcome to My Static Website!</h1>
         <img src="http://your-bucket-name.s3.amazonaws.com/Coffee.png" alt="Coffee Image">
     </body>
     </html>
     ```

8. **Check Public IP of EC2 Instance**
   - **Verify Deployment:** Open a web browser and navigate to the public IP of your EC2 instance to view your static website.
     ```
     http://your-ec2-public-dns
     ```

These steps guide you through setting up an EC2 instance, installing and configuring a web server, creating and configuring an S3 bucket, and deploying a static website with an image hosted on S3.
