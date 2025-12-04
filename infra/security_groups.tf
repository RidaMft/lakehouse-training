##############################
# Security Group EC2 pour Docker services
##############################
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group pour EC2 avec Docker services"
  vpc_id      = data.aws_vpc.default.id

  # ===============================
  # Accès SSH (optionnel, attention sécurité)
  # ===============================
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  # ===============================
  # MinIO
  # ===============================
  ingress {
    description = "MinIO API"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MinIO Console"
    from_port   = 9001
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ===============================
  # Jupyter Notebook (Spark)
  # ===============================
  ingress {
    description = "Jupyter Notebook"
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ===============================
  # Iceberg REST Catalog (Nessie)
  # ===============================
  ingress {
    description = "Iceberg REST Catalog"
    from_port   = 19120
    to_port     = 19120
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ===============================
  # Trino
  # ===============================
  ingress {
    description = "Trino"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ===============================
  # Superset
  # ===============================
  ingress {
    description = "Superset"
    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ===============================
  # Spark UI et Spark Master
  # ===============================
  ingress {
    description = "Spark UI"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Spark Master"
    from_port   = 7077
    to_port     = 7077
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ===============================
  # PostgreSQL
  # ===============================
  ingress {
    description = "Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # ===============================
  # DBEaver
  # ===============================
  ingress {
    description = "DBEaver"
    from_port   = 8881
    to_port     = 8881
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ===============================
  # Autoriser toutes les connexions sortantes
  # ===============================
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}