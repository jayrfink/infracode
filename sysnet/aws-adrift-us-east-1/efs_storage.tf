resource "aws_security_group" "efs-secgrp" {
   name = "efs-secgrp"
   vpc_id = "${aws_vpc.vpc-adrift.id}"

   ingress {
     from_port = 2049
     to_port = 2049
     protocol = "tcp"
     cidr_blocks     = ["0.0.0.0/0"]
   }

}

resource "aws_efs_file_system" "efs-adrift" {
   creation_token = "efs-adrift"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = "true"
 tags = {
     Name = "efs-adrift"
   }
}

resource "aws_efs_mount_target" "efs-adrift" {
   file_system_id  = "${aws_efs_file_system.efs-adrift.id}"
   subnet_id = "${aws_subnet.net-adrift-p.id}"
  security_groups = [
        "${aws_security_group.adrift-secgrp-egress.id}",
        "${aws_security_group.efs-secgrp.id}",
  ]

}


