data "aws_secretsmanager_secret" "aurora_creds" {
  name = "my_aurora_db"
}

data "aws_secretsmanager_secret_version" "aurora_creds" {
  secret_id = data.aws_secretsmanager_secret.aurora_creds.id
}

data "aws_availability_zones" "available" {
  state = "available"
}