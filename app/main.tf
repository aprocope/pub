locals {
  public_subnets = [for item in var.public_subnet_names : "${item}-${var.env}"]
  private_subnets = [for item in var.private_subnet_names : "${item}-${var.env}"]
}

module "nginx" {
  source = "../modules/ecs"

  vpc_name = "${var.vpc_name}-${var.env}"
  vpc_cidr = "10.32.0.0/16"

  azs       = var.azs
  env       = var.env
  
  public_subnet_names = local.public_subnets
  public_subnet_cidr =  ["10.32.0.0/24", "10.32.1.0/24"]

  private_subnet_names = local.private_subnets
  private_subnet_cidr =  ["10.32.2.0/24", "10.32.3.0/24"]

  service_name = "${var.service_name}-${var.env}"
  cluster_name = "${var.cluster_name}-${var.env}"
  container_name = "${var.container_name}-${var.env}"
  container_image = "nginx:latest"

  lb_name = "${var.lb_name}-${var.env}"
  tg_name = "${var.tg_name}-${var.env}"

  bucket_name = "ecsbucketandreprocope-${var.env}"
    
}
