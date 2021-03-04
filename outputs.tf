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

