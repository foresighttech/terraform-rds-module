output "cluster_id" {
    value = aws_rds_cluster.postgres.cluster_identifier
}

output "cluster_endpoint" {
    value = aws_rds_cluster.postgres.endpoint
}

output "master_username" {
    value = aws_rds_cluster.postgres.master_username
}

output "master_password" {
    value = aws_rds_cluster.postgres.master_password
}

output "security_group_id" {
    value = aws_security_group._.id
}