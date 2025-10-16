variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "lambda_name" {
  type        = string
  description = "Lambda function name"
  default     = "my-lambda-function"
}