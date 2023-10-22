###################################################
#ECS Outputs
###################################################

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.nginx_cluster.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.nginx_cluster.arn
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.nginx_task.arn
}

output "ecs_task_definition_family" {
  description = "Family of the ECS task definition"
  value       = aws_ecs_task_definition.nginx_task.family
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.nginx_service.name
}

output "ecs_service_cluster" {
  description = "ID of the ECS cluster for the service"
  value       = aws_ecs_service.nginx_service.cluster
}

###################################################
#IAM Outputs
###################################################

output "iam_role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.ecs_execution_role.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.ecs_execution_role.arn
}

###################################################
#Load Balancer Outputs
###################################################

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.ecs_alb.name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.ecs_alb.arn
}


output "target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = aws_lb_target_group.ecs_target_group.arn
}

output "target_group_name" {
  description = "Name of the ALB Target Group"
  value       = aws_lb_target_group.ecs_target_group.name
}

output "listener_arn" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.ecs_lb_listener.arn
}

output "listener_port" {
  description = "Port of the ALB listener"
  value       = aws_lb_listener.ecs_lb_listener.port
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.ecs_bucket.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.ecs_bucket.arn
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ecs_security_group.id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = aws_security_group.ecs_security_group.name
}

