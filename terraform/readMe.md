create a secure Amazon S3 bucket to store the Terraform state, you need to set up the bucket along with an AWS DynamoDB table.Terraform uses the S3 bucket to save the infrastructure design layout file (terraform.tfstate), and it uses DynamoDB to lock the state file. This prevents two team members (or two concurrent CI/CD pipeline runs) from changing the infrastructure at the exact same time and breaking it.

copy backend-setup.tf on the local machine and folow the following steps

### Step 1: Initialize and Build the Resources
Run these commands locally on the machine to initialize AWS and deploy the bucket structures:

```
terraform init
terraform apply -auto-approve
```

### step 2 Copy the unique bucket name string printed out by the terminal
Look at the terminal output summary and copy the string value printed under s3_bucket_name.

### Step 3: Migrate the Existing Local State
terraform init -migrate-state

Now that the S3 storage bucket actively exists in the AWS cloud,configure the primary code repository to use it

### Step 4: Configure Terraform to Use the New bucket

update the bucket parameter in the main application main.tf file inside terraform/ folder:

Save, commit, and push the code to the GitHub main branch

