variable "tags" {
  description = "Mandatory tags for all resources"
  type        = map(string)
  validation {
    condition     = alltrue([for k in ["Environment", "Owner", "Project", "ManagedBy"] : contains(keys(var.tags), k)])
    error_message = "Missing required tags: Environment, Owner, Project, ManagedBy"
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "name" {
  description = "default name for all resources"
  default = "prisma"
}

variable "environment" {
  description = "Environment name"
}