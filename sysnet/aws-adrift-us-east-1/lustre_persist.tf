resource "aws_security_group" "lustre-secgrp" {
   name = "lustre-secgrp"
   vpc_id = "${aws_vpc.vpc-adrift.id}"

   ingress {
     from_port = 2049
     to_port = 2049
     protocol = "tcp"
     cidr_blocks     = ["0.0.0.0/0"]
   }
}

resource "aws_fsx_lustre_file_system" "lustre-storage-programs" {
    subnet_ids = [
	"${aws_subnet.subnet-adrift-w.id}" 
	]
    storage_capacity = 1200
  security_group_ids = [
        "${aws_security_group.adrift-egress.id}",
        "${aws_security_group.adrift-lnet.id}",
        "${aws_security_group.lustre-secgrp.id}",
	]
	storage_type = "HDD"
	drive_cache_type  = "READ"
	per_unit_storage_throughput = 40
	deployment_type =  "PERSISTENT_1"
	automatic_backup_retention_days =  0
	tags = {
    Name = "adrift"
	}


}
