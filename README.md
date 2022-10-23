# Terraform AWS State

This is a simple terraform module for provisioning S3 and DynamoDB for managing terraform
state. This will create a private S3 bucket with encryption and verionining enabled, as
well as a DynamoDB table. To use this for your main terraform configuration, use:

    terraform {
        backend "s3" {
            bucket         = "<s3_bucket_name>"
            key            = "<prefix>/terraform.tfstate"
            region         = "<region>"
            dynamodb_table = "<dynamodb_table_name>"
            encrypt        = true
        }
    }

The bucket name and dynamodb table name are provided as outputs from this script. The prefix
allows you to host multiple terraform states within the same bucket.

## Inputs

 * `aws_region` - Optional. AWS region to use. Defaults to `us-east-1`
 * `id` - Required. Unique ID for naming. This must be globally unique as it is used to name a S3
    bucket, so a fully qualified domain name is recommended.

## Deploying

To configure the terraform state, run the folowing:

    # terraform init
    # terraform apply -var id=my.site.com