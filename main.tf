module "us_east_1" {
  source = "./modules"
  providers = {
    aws = aws.us_east_1
  }
  vpc_cidr = "10.66.108.0/22"
  tags = var.resource_tags
  environment = var.environment
}

module "us_east_2" {
  source = "./modules"
  providers = {
    aws = aws.us_east_2
  }
  vpc_cidr = "10.18.92.0/22"
  tags = var.resource_tags
  environment = var.environment
}

module "us_west_1" {
  source = "./modules"
  providers = {
    aws = aws.us_west_1
  }
  vpc_cidr = "10.66.112.0/22"
  tags = var.resource_tags
  environment = var.environment
}

module "us_west_2" {
  source = "./modules"
  providers = {
    aws = aws.us_west_2
  }
  vpc_cidr = "10.66.116.0/22"
  tags = var.resource_tags
  environment = var.environment
}
