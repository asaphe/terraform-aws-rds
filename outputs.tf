output "cluster_arn" {
  description = "ARN of the RDS cluster."
  value       = aws_rds_cluster.this.arn
}

output "cluster_id" {
  description = "ID of the RDS cluster."
  value       = aws_rds_cluster.this.id
}

output "cluster_resource_id" {
  description = "Resource ID of the RDS cluster, used for IAM policies."
  value       = aws_rds_cluster.this.cluster_resource_id
}

output "cluster_endpoint" {
  description = "Primary writer endpoint of the cluster."
  value       = aws_rds_cluster.this.endpoint
}

output "cluster_engine_version" {
  description = "Database engine version of the cluster."
  value       = aws_rds_cluster.this.engine_version
}

output "cluster_reader_endpoint" {
  description = "Reader endpoint for the RDS cluster."
  value       = aws_rds_cluster.this.reader_endpoint
}

output "cluster_database_name" {
  description = "Name of the initial database created (if specified)."
  value       = var.database_name
}

output "cluster_master_password" {
  description = "Master password for the cluster (only available when create_master_password is true)."
  value       = aws_rds_cluster.this.master_password
  sensitive   = true
}

output "cluster_port" {
  description = "Port on which the cluster accepts connections."
  value       = aws_rds_cluster.this.port
}

output "cluster_master_username" {
  description = "Master username for the database cluster."
  value       = aws_rds_cluster.this.master_username
  sensitive   = true
}

output "cluster_hosted_zone_id" {
  description = "Route53 hosted zone ID associated with the cluster."
  value       = aws_rds_cluster.this.hosted_zone_id
}

output "cluster_instance_endpoints" {
  description = "List of endpoints for all RDS cluster instances."
  value       = [for instance in aws_rds_cluster_instance.this : instance.endpoint]
}

output "cluster_instance_ids" {
  description = "List of IDs for all RDS cluster instances."
  value       = [for instance in aws_rds_cluster_instance.this : instance.id]
}

output "cluster_instance_dbi_resource_ids" {
  description = "List of region-unique DBI resource identifiers for the instances."
  value       = [for instance in aws_rds_cluster_instance.this : instance.dbi_resource_id]
}

output "security_group_id" {
  description = "List of VPC security group IDs associated with the cluster."
  value       = var.vpc_security_group_ids
}
