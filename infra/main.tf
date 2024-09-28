terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

module "s3" {
  source                                = "./modules/s3"
  cloudfront_origin_access_identity_arn = module.cloudfront.origin_access_identity_arn
}

module "cloudfront" {
  source                      = "./modules/cloudfront"
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
}

module "lambda" {
  source = "./modules/lambda"
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  lambda_name       = module.lambda.function_name
  lambda_invoke_arn = module.lambda.invoke_arn
}
