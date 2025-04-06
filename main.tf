resource "aws_resourcegroups_group" "name" {
  name = "tf-rgoup"
  resource_query {
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]
      TagFilters = [
        {
          Key    = "Environment"
          Values = ["dev"]
        }
      ]
    })
  }
}

module "vpc" {
  source = "./vpc"
}

module "sg" {
  source = "./sg"
  vpc_id = module.vpc.vpc_id
  
}

module "ec2" {
  source = "./ec2"
  subnet_id = module.vpc.subnet_id
  sg_id = module.sg.sg_id
}