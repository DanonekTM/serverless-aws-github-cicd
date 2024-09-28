# CI/CD Pipeline for Serverless Full Stack Deployment

### 🚀 What Does It Do?

This pipeline automates the deployment of a **serverless** infrastructure on AWS, leveraging:

- **S3** for frontend hosting
- **Lambda** & **API Gateway** for backend services
- **CloudFront** for CDN and SSL termination

This setup provides a highly **cost-effective** and **scalable** full-stack application without the need to manage any servers.

---

### 🔧 Prerequisites

Before you start, make sure you have:

1. An **AWS account**.
2. A user with sufficient **permissions** configured in your AWS CLI.

That's all you need!

---

### 🚀 Getting Started

Follow these simple steps to deploy your serverless infrastructure:

1. **Create a Repository**  
   Start by creating your own repository to test the pipeline.
2. **Clone the Repo & Set Up Credentials**  
    Clone this repository and navigate to the `setup` folder. Run the script:

   ```bash
   ./create_pipeline_creds.sh
   ```

   This will create an AWS user following the **principle of least privilege (PoLP)**, which you can use for your repository.

3. **Configure GitHub Secrets**  
   Once the script runs, it will output the necessary variables. Add these as **GitHub Secrets** in your repository.

4. **Configure the Infrastructure**  
   Modify the `infra/variables.tf` file with your desired AWS **region**. By default this is set to `eu-west-2`

5. **Push Your Code**  
   Push the code to your repository, and watch the pipeline work!

A step by step tutorial available <a href="https://">here</a>.

---

### ⏱️ Deployment Time

The entire pipeline takes approximately **6.5 minutes** to complete from start to finish.

---

### 🎉 Success!

Congratulations! You’ve successfully deployed a **full-stack, serverless** application. Feel free to use this as a template for your projects.

---

Enjoy building on AWS serverless!
