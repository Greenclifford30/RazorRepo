resource "aws_iam_role" "razorshop_db" {
  name = "razorshop-db-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "rds.amazonaws.com" }
        Action    = "sts:AssumeRole"
      },
    ]
  })

  tags = {
    Name = "razorshop-db-role"
  }
}

resource "aws_iam_policy" "razorshop_db" {
  name        = "razorshop-db-policy"
  policy      = data.aws_iam_policy_document.example.json
}

data "aws_iam_policy_document" "razorshop_db" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [
"*"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "rds-data:ExecuteSql",
    ]
    resources = [
      aws_rds_cluster.razorshop_db_cluster.arn,
    ]
    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "razorshop_db" {
  policy_arn = aws_iam_policy.razorshop_db.arn
  role       = aws_iam_role.razorshop_db.name
}

