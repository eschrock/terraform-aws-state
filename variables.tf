variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "id" {
  description = "Globally unique identifier (FQDN recommended)"
  type        = string
}