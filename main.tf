resource "aws_rds_cluster" "this" {
  cluster_identifier = var.name

  engine         = var.engine
  engine_mode    = var.engine_mode
  engine_version = local.engine_version

  allow_major_version_upgrade = var.allow_major_version_upgrade
  availability_zones          = var.availability_zones

  database_name   = var.database_name
  master_username = var.username
  master_password = !var.iam_database_authentication_enabled ? local.master_password : null

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  apply_immediately = var.apply_immediately

  port                   = var.port
  vpc_security_group_ids = var.vpc_security_group_ids

  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id

  db_subnet_group_name = aws_db_subnet_group.this.name

  backtrack_window     = var.backtrack_window
  deletion_protection  = var.deletion_protection
  enable_http_endpoint = var.enable_http_endpoint

  copy_tags_to_snapshot     = var.copy_tags_to_snapshot
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  iam_roles                           = var.use_rds_cluster_role_association ? [] : var.iam_roles

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  tags = var.tags
}
