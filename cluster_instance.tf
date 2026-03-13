resource "aws_rds_cluster_instance" "this" {
  for_each = merge(local.writer_replica_instances, local.reader_replica_instances)

  identifier         = "${var.name}-${each.key}"
  cluster_identifier = aws_rds_cluster.this.id

  engine         = var.engine
  engine_version = local.engine_version

  apply_immediately                     = var.apply_immediately
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  availability_zone                     = length(var.availability_zones) > 0 ? var.availability_zones[0] : null
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  ca_cert_identifier                    = var.ca_cert_identifier
  db_parameter_group_name               = length(aws_db_parameter_group.this) > 0 ? aws_db_parameter_group.this[0].name : null
  db_subnet_group_name                  = aws_db_subnet_group.this.name
  instance_class                        = each.value.instance_type
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = var.monitoring_role_arn
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period
  preferred_maintenance_window          = var.preferred_maintenance_window
  promotion_tier                        = each.value.promotion_tier
  publicly_accessible                   = var.publicly_accessible

  tags = var.tags
}
