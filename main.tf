provider "aws" {
  region = "us-east-1"
}

resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "example-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = ["subnet-03151fd3b6eaba29d", "subnet-00558958d15ffec4b"]
    security_groups = ["sg-0149ec6f0649ba6fe"]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  tags = {
    Name = "example-kafka-cluster"
  }
}

resource "aws_security_group" "kafka_sg" {
  name        = "kafka_sg"
  description = "Security group for MSK cluster"

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "bootstrap_brokers" {
  value = aws_msk_cluster.kafka_cluster.bootstrap_brokers
}

