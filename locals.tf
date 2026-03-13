locals {
  master_password = !var.iam_database_authentication_enabled ? (
    var.create_master_password ? random_password.master_password[0].result : var.user_master_password
  ) : null

  engine_version = var.engine_version != null ? var.engine_version : (
    length(data.aws_rds_engine_version.default) > 0 ? data.aws_rds_engine_version.default[0].version : "13.7" # Use a fallback version
  )

  writer_replica_instances = { for i in range(1, var.writer_replica_count + 1) :
    "writer-${i}" => {
      instance_type  = var.instance_type
      promotion_tier = i - 1 //writers should start at promotion tier 0 and up
    }
  }
  reader_replica_instances = { for i in range(1, var.reader_replica_count + 1) :
    "reader-${i}" => {
      instance_type  = var.instance_type_replica
      promotion_tier = 15 - i + 1 //max promotion tier is 15, so readers should start at 15 and down
    }
  }
}
