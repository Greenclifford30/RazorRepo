resource "aws_rds_cluster" "razorshop_db_cluster" {
  engine             = "aurora"
  engine_mode        = "serverless"
  database_name      = "razorshopdb"
  master_username    = "admin"
  manage_master_user_passord    = true
  backup_retention_period = 7
  preferred_backup_window = "03:00-04:00"
  deletion_protection = false
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.aurora.id]

  scaling_configuration {
    auto_pause = true
    min_capacity = 1
    max_capacity = 8
    seconds_until_auto_pause = 300
    timeout_action = "ForceApplyCapacityChange"
  }

  tags = {
    Name = "razorshop-db-cluster"
  }
}

resource "aws_rds_cluster_instance" "razorshop_db_instance" {
  identifier         = "razorshop-db-instance"
  engine             = "aurora"
  instance_class     = "serverless"
  apply_immediately  = true
  cluster_identifier = aws_rds_cluster.razorshop_db_cluster.id
  db_subnet_group_name = aws_db_subnet_group.aurora.name

  tags = {
    Name = "razorshop-db-instance"
  }
}