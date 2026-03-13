variable "allow_major_version_upgrade" {
  description = "(Optional) If true, allows major version upgrades for the database engine."
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "(Optional) If true, modifications are applied immediately instead of during the next maintenance window."
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "(Optional) List of AWS availability zones for the cluster."
  type        = list(string)
  default     = []
}

variable "auto_minor_version_upgrade" {
  description = "(Optional) If true, enables automatic minor version upgrades for instances within the cluster."
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "(Optional) The number of days to retain backups for the RDS cluster."
  type        = number
  default     = 7
}

variable "backtrack_window" {
  description = "(Optional) The target backtrack window, in seconds. Only available for Aurora MySQL."
  type        = number
  default     = 0
}

variable "ca_cert_identifier" {
  description = "(Optional) Identifier of the CA certificate for the DB cluster."
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = "(Optional) Whether to copy all tags to snapshots."
  type        = bool
  default     = true
}

variable "create_master_password" {
  description = "(Optional) Whether to create a random master password."
  type        = bool
  default     = true
}

variable "user_master_password" {
  description = "(Optional) Master password provided by the user (only used if create_master_password is false)."
  type        = string
  default     = null
  sensitive   = true
}

variable "database_name" {
  description = "(Optional) Name for the initial database to be created on cluster creation. Must be 1-63 characters long and contain only alphanumeric characters or underscores (_)."
  type        = string
  default     = null

  validation {
    condition = (
      var.database_name == null ||
      (length(coalesce(var.database_name, "_")) >= 1 && length(coalesce(var.database_name, "_")) <= 63 && can(regex("^[a-zA-Z0-9_]+$", var.database_name)))
    )
    error_message = "Database name must be 1-63 characters long and can only contain alphanumeric characters (a-z, A-Z, 0-9) or underscores (_)."
  }
}

variable "deletion_protection" {
  description = "(Optional) Whether to enable deletion protection on the RDS cluster."
  type        = bool
  default     = true
}

variable "enable_http_endpoint" {
  description = "(Optional) Enable HTTP endpoint (Data API) for Aurora Serverless."
  type        = bool
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  description = "(Optional) List of log types to export to CloudWatch."
  type        = list(string)
  default     = []
}

variable "engine" {
  description = "(Required) The database engine to use (e.g., aurora-mysql, aurora-postgresql)."
  type        = string
}

variable "engine_mode" {
  description = "(Optional) The engine mode to use (e.g., provisioned, serverless)."
  type        = string
  default     = null
}

variable "engine_version" {
  description = "(Optional) The version of the database engine to use."
  type        = string
  default     = null
}

variable "final_snapshot_identifier" {
  description = "(Optional) The identifier for the final snapshot when deleting the cluster."
  type        = string
  default     = null
}

variable "feature_name" {
  description = "(Optional) The name of the feature to associate with the IAM role (e.g., s3Import)."
  type        = string
  default     = "s3Import"
}

variable "iam_database_authentication_enabled" {
  description = "(Optional) Enable IAM authentication for database users."
  type        = bool
  default     = false
}

variable "iam_roles" {
  description = "(Optional) List of IAM role ARNs to associate with the RDS cluster."
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "(Required) The instance class for the primary RDS cluster instance."
  type        = string
}

variable "instance_type_replica" {
  description = "(Optional) Instance class to use for read replicas. Defaults to instance_type."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "(Optional) ARN of the KMS key to use for encryption."
  type        = string
  default     = null
}

variable "monitoring_interval" {
  description = "(Optional) Interval in seconds for enhanced monitoring. 0 to disable."
  type        = number
  default     = 0
}

variable "monitoring_role_arn" {
  description = "ARN of the IAM role for RDS enhanced monitoring. Required if monitoring_interval is set."
  type        = string
  default     = ""

  validation {
    condition     = var.monitoring_interval == 0 || length(var.monitoring_role_arn) > 0
    error_message = "If monitoring_interval is set, monitoring_role_arn must also be provided."
  }
}

variable "name" {
  description = "(Required) Name prefix to use for cluster and associated resources."
  type        = string
}

variable "parameter_group_family" {
  description = "(Optional) The family of the DB parameter group."
  type        = string
  default     = null
}

variable "parameters" {
  description = "(Optional) A list of DB parameter group parameters to apply."
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate")
  }))
  default = []
}

variable "performance_insights_enabled" {
  description = "(Optional) Whether to enable Performance Insights."
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "(Optional) KMS key ID to use for encrypting Performance Insights data."
  type        = string
  default     = null
}

variable "performance_insights_retention_period" {
  description = "(Optional) Retention period in days for Performance Insights (e.g., 7 or 731)."
  type        = number
  default     = null
}

variable "port" {
  description = "(Optional) Port for the DB cluster to listen on."
  type        = number
  default     = null
}

variable "preferred_backup_window" {
  description = "(Optional) Time window for daily automated backups."
  type        = string
  default     = null
}

variable "preferred_maintenance_window" {
  description = "(Optional) Time window for maintenance updates."
  type        = string
  default     = null
}

variable "publicly_accessible" {
  description = "(Optional) Whether the instances should be publicly accessible."
  type        = bool
  default     = false
}

variable "reader_replica_count" {
  description = "(Optional) Number of reader replica instances to create."
  type        = number
  default     = 0
}

variable "skip_final_snapshot" {
  description = "(Optional) Whether to skip the final snapshot on cluster deletion."
  type        = bool
  default     = true
}

variable "storage_encrypted" {
  description = "(Optional) Whether to enable storage encryption."
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "(Required) List of subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "tags" {
  description = "(Optional) Tags to apply to all created resources."
  type        = map(string)
  default     = {}
}

variable "username" {
  description = "(Optional) Master username for the DB cluster."
  type        = string
  default     = "admin"
}

variable "use_rds_cluster_role_association" {
  description = "(Optional) Whether to associate IAM roles with the RDS cluster."
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "(Required) List of VPC security group IDs to associate with the DB cluster."
  type        = list(string)
}

variable "writer_replica_count" {
  description = "(Optional) Number of writer instances to create."
  type        = number
  default     = 1
}
