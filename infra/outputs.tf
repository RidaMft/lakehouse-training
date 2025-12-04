# outputs.tf

# IP publique de l'instance
output "iceberg_public_ip" {
  value = aws_instance.iceberg.public_ip
}

# IP privée de l'instance
output "iceberg_private_ip" {
  value = aws_instance.iceberg.private_ip
}

# URL Jupyter Notebook (Spark)
output "iceberg_jupyter_url" {
  value = "http://${aws_instance.iceberg.public_ip}:8888"
}

# URL Trino Web UI
output "iceberg_trino_url" {
  value = "http://${aws_instance.iceberg.public_ip}:8080"
}

# URL Superset
output "iceberg_superset_url" {
  value = "http://${aws_instance.iceberg.public_ip}:8088"
}

# URL DBeaver
output "iceberg_dbeaver_url" {
  value = "http://${aws_instance.iceberg.public_ip}:8881"
}

# URL MinIO Console
output "iceberg_minio_url" {
  value = "http://${aws_instance.iceberg.public_ip}:9001"
}

# URL Nessie REST API
output "iceberg_nessie_url" {
  value = "http://${aws_instance.iceberg.public_ip}:19120"
}

# Nom de la clé SSH utilisée pour l'instance
output "key_name" {
  value = aws_key_pair.default.key_name
}
