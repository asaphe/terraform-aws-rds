data "aws_rds_engine_version" "default" {
  count = var.engine_version == null ? 1 : 0

  engine                 = var.engine
  default_only           = true
  parameter_group_family = var.parameter_group_family
}
