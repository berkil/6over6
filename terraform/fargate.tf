resource "aws_ecs_cluster" "sos" {
  name = var.cluster_name
}

resource "aws_ecs_cluster_capacity_providers" "sos" {
  cluster_name = aws_ecs_cluster.sos.name

  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "sos" {
  family                   = var.cluster_name
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
  container_definitions    = <<DEFINITION
    [
                {
                    "name": "${var.cluster_name}-container",
                    "image": "${var.container_image}",
                    "cpu": 0,
                    "mountPoints": [],
                    "volumesFrom": [],
                    "logConfiguration": {
                        "logDriver": "awslogs",
                        "options": {
                            "awslogs-group": "/ecs/${var.cluster_name}",
                            "awslogs-region": "${data.aws_region.current.name}",
                            "awslogs-stream-prefix": "ecs"
                        }
                    }
                }
            ]
    DEFINITION
  execution_role_arn       = aws_iam_role.sos.arn
  task_role_arn            = aws_iam_role.sos.arn
  requires_compatibilities = ["FARGATE"]

  depends_on = [aws_iam_role.sos]
}

resource "aws_ecs_service" "sos" {
  name                               = var.cluster_name
  enable_ecs_managed_tags            = true
  cluster                            = aws_ecs_cluster.sos.id
  task_definition                    = aws_ecs_task_definition.sos.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  platform_version                   = "1.3.0"
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.sos_sg_ecs.id]
    subnets          = aws_subnet.sos_private_subnet[*].id
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

  depends_on = [aws_ecs_task_definition.sos]
}

resource "aws_cloudwatch_log_group" "sos" {
  name              = "/ecs/${var.cluster_name}"
  retention_in_days = 7
}
