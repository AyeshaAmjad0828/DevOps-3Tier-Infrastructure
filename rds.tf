# RDS PostgreSQL
resource "aws_db_instance" "postgresql_db" {
  storage_type         = "gp2"
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  identifier           = "postgresql-db-aa"
  db_name              = "reviews"
  username             = "postgres"
  password             = "admin123"
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.postgressql_subnet_group.name
  depends_on = [ aws_security_group.postgresql_sg ]
  vpc_security_group_ids = [aws_security_group.postgresql_sg.id]
}