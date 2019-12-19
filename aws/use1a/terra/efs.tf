resource "aws_efs_file_system" "efs001" {
 creation_token = "efs-efs001"
 performance_mode = "generalPurpose"
 throughput_mode = "bursting"
 encrypted = "true"
 tags = {
  Name = "efs001"
 }
}

resource "aws_efs_mount_target" "efs-mnt" {
 file_system_id  = "efs-mnt" // This fails but still creates it...
 subnet_id = "SUBNET_ID"
 security_groups = [ "SECGRP1", ]
}
