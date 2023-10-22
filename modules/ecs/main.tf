resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_names)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = var.public_subnet_names[count.index]
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_names)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = var.private_subnet_names[count.index]
  }
}

resource "aws_security_group" "ecs_security_group" {
  vpc_id = aws_vpc.vpc.id
  name = "ecs-sg-${var.env}"
   ingress {
     from_port   = 80
     to_port     = 80
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = {
    Name = "public-route-table-${var.env}"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private-route-table-${var.env}"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_names)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_names)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_ecs_cluster" "nginx_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task"
  network_mode             = "awsvpc"
  memory = 512
  cpu    = 256
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = var.container_image
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        },
      ]
    },
  ])
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_policy" "ecs_s3_policy" {
  name        = "ecs-s3-policy-${var.env}"
  description = "Allow ECS tasks to write to S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
        ],
        Effect   = "Allow",
        Resource = aws_s3_bucket.ecs_bucket.arn,
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_execution_role_policy" {
  name =  "attachment_uno-${var.env}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.ecs_execution_role.name]
}

resource "aws_iam_role_policy_attachment" "ecs_s3_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_s3_policy.arn
  role       = aws_iam_role.ecs_execution_role.name
}

resource "aws_ecs_service" "nginx_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.nginx_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = aws_subnet.private[*].id
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = var.container_name
    container_port   = 80  
  }

  depends_on = [aws_iam_policy_attachment.ecs_execution_role_policy]
}

resource "aws_lb" "ecs_alb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id

  

  enable_http2 = true

  security_groups = [aws_security_group.ecs_security_group.id]

  enable_deletion_protection = false
}


resource "aws_lb_listener" "ecs_lb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "ecs_alb_rule" {
  listener_arn = aws_lb_listener.ecs_lb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }

  condition {
    path_pattern {
      values  = ["/"] 
    }  
  }
}

resource "aws_lb_target_group" "ecs_target_group" {
  name        = var.tg_name
  port        = 80  
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"  
}

resource "aws_s3_bucket" "ecs_bucket" {
  bucket = var.bucket_name 
  acl    = "private"  

}