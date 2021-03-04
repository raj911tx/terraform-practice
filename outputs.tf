output "instance_id" {
  value       = aws_instance.example.id
  sensitive   = false
  description = "ID of the EC2 instance"
}

output "instance_public_ip" {
  value       = aws_instance.example.public_ip
  sensitive   = false
  description = "Public IP address of the EC2 instance"
}

output "db_connect_string" {
  value       = "Server=${aws_db_instance.database.address};Database=ExampleDB;Uid=${var.db_username};Pwd=${var.db_password}"
  sensitive   = true
  description = "MySQL database connection string"
}

output "vpc_id" {
  description = "ID of project VPC"
  value = module.vpc.vpc_id
}

//terraform output vpc_id

output "db_username" {
  description = "Database administrator username"
  value = aws_db_instance.database.username
  sensitive = true
}

output "db_password" {
  description = "Database administrator password"
  value = aws_db_instance.database.password
  sensitive = true
}

//terraform output -json