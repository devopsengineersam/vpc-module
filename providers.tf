terraform {
  required_version = "1.9.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
  }
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::533267037417:role/terraform-role"
  }
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::533267037417:role/terraform-role"
  }
  alias  = "us_east_2"
  region = "us-east-2"
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::533267037417:role/terraform-role"
  }
  alias  = "us_west_1"
  region = "us-west-1"
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::533267037417:role/terraform-role"
  }
  alias  = "us_west_2"
  region = "us-west-2"
}