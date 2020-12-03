resource "random_password" "rds" {
    length = 16
    special = false
}

resource "aws_db_subnet_group" "main" {
  name       = var.env
  subnet_ids = var.subnet_ids
}

data "aws_kms_key" "_" {
  key_id = "alias/aws/rds"
}

resource "aws_rds_cluster" "postgres" {
  cluster_identifier = "postgres-${var.env}"
  db_subnet_group_name = aws_db_subnet_group.main.name
  master_username = "auroraadmin"
  master_password = random_password.rds.result
  skip_final_snapshot = false
  vpc_security_group_ids = [aws_security_group._.id]
  engine = "aurora-postgresql"
  engine_version = var.engine_mode == "serverless" ? "10.7" : "11.6"
  engine_mode = var.engine_mode
  storage_encrypted = true
  kms_key_id = data.aws_kms_key._.arn
  lifecycle {
    ignore_changes = [snapshot_identifier, scaling_configuration, engine_version]
  }
  tags = map(
    "backup", "true"
  )
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  cluster_identifier = aws_rds_cluster.postgres.id
  instance_class     = "db.r4.large"
  engine = "aurora-postgresql"
  engine_version = var.engine_mode == "serverless" ? "10.7" : "11.6"
  publicly_accessible = var.publicly_accessible
}