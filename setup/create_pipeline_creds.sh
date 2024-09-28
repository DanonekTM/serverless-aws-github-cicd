#!/bin/bash

# Ask for the AWS Region
read -p "Enter the AWS region (e.g., eu-west-2): " AWS_REGION

# Ask for the Terraform S3 bucket name
read -p "Enter the Terraform backend S3 bucket name: " TERRAFORM_S3_BUCKET

# If bucket doesn't exist create it
if aws s3api head-bucket --bucket "$TERRAFORM_S3_BUCKET" 2>/dev/null; then
    echo "Bucket '$TERRAFORM_S3_BUCKET' already exists, skipping..."
else
    echo "Bucket '$TERRAFORM_S3_BUCKET' does not exist. Creating bucket..."
    aws s3api create-bucket --bucket "$TERRAFORM_S3_BUCKET" --region "$AWS_REGION" \
        --create-bucket-configuration LocationConstraint="$AWS_REGION"
fi

# Step 1: Create the IAM user
aws iam create-user --user-name Pipeline

# Step 2: Replace <TERRAFORM_S3_BUCKET> and <AWS_REGION> placeholders in pipeline-policy.json
sed -i "s/<TERRAFORM_S3_BUCKET>/${TERRAFORM_S3_BUCKET}/g" pipeline-policy.json
sed -i "s/<AWS_REGION>/${AWS_REGION}/g" pipeline-policy.json

# Step 3: Create the managed policy from the updated pipeline-policy.json and capture the output
POLICY_OUTPUT=$(aws iam create-policy --policy-name Pipeline_Policy --policy-document file://pipeline-policy.json)

# Step 4: Extract the Policy ARN from the response using jq
POLICY_ARN=$(echo $POLICY_OUTPUT | jq -r '.Policy.Arn')

# Step 5: Attach the managed policy to the user
aws iam attach-user-policy --user-name Pipeline --policy-arn $POLICY_ARN

# Step 6: Create access keys for the user and capture the response
ACCESS_KEYS=$(aws iam create-access-key --user-name Pipeline)

# Step 7: Extract AccessKeyId and SecretAccessKey from the response using jq
ACCESS_KEY_ID=$(echo $ACCESS_KEYS | jq -r '.AccessKey.AccessKeyId')
SECRET_ACCESS_KEY=$(echo $ACCESS_KEYS | jq -r '.AccessKey.SecretAccessKey')

# Step 8: Output the AccessKeyId and SecretAccessKey
echo "Update Secrets with the below Key-Value pairs:"
echo "AWS_ACCESS_KEY: $ACCESS_KEY_ID"
echo "AWS_SECRET_KEY: $SECRET_ACCESS_KEY"
echo "AWS_REGION: $AWS_REGION"
echo "TERRAFORM_S3_BUCKET: $TERRAFORM_S3_BUCKET"
