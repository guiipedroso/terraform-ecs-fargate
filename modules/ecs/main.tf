resource "aws_ecr_repository" "this" {
  name                 = "guipedroso-ecs-portal"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "guipedroso-ecs-portal"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "guipedroso-ecs-cluster"

  tags = {
    Name = "guipedroso-ecs-project"
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 100
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "guipedroso-ecs-portal-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      "name" : "guipedroso-ecs-portal-container",
      "image" : "${aws_ecr_repository.this.repository_url}:latest",
      "cpu" : 1024,
      "memory" : 2048,
      "essential" : true,
      "environment" : [
        { "name" : "HOSTNAME", "value" : "0.0.0.0" },
        { "name" : "PORT", "value" : "3000" }
      ],
      "portMappings" : [
        {
          "containerPort" : 3000,
          "hostPort" : 3000,
          "protocol" : "tcp"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/guipedroso/ecs/portal",
          "awslogs-region" : "us-east-1",
          "awslogs-create-group" : "true",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "guipedroso-ecs-portal-task-definition"
  }
}

resource "aws_ecs_service" "this" {
  cluster         = aws_ecs_cluster.this.id
  name            = "guipedroso-ecs-portal-service"
  desired_count   = 1
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.this.arn

  network_configuration {
    subnets          = [var.private_subnet_1a_id, var.private_subnet_1b_id]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "guipedroso-ecs-portal-container"
    container_port   = 3000
  }

  tags = {
    Name = "guipedroso-ecs-portal-service"
  }
}
