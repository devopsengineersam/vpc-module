variable "resource_tags" {
  description = "Mandatory tags for all resources"
  type        = map(string)
  default = {
    Environment = "POC"
    Owner       = "EIS"
    Project     = "prisma-dspm"
    ManagedBy   = "Terraform"
  }
}

variable "environment" {
  description = "Environment name"
}