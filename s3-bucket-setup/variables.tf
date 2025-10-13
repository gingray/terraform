variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name"
  default     = "real-unique-bucket-name-xaxaxaxax-123"
}

variable "availability_zone" {
  type        = string
  description = "AWS availability zone"
  default     = "eu-central-1a"
}

variable "prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "mine-tf"
}

variable "iam_user_name" {
  type        = string
  description = "IAM user name"
  default     = "public-s3-bucket-tf-user"
}