variable "public_key" {
  type        = string
  description = "Path to the public ssh key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t2.medium"
}

variable "volume_size" {
  type        = number
  description = "Volume size in GB"
  default     = 40
}