resource "aws_security_group" "lustre-sg" {
   name = "lustre-sg"
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
        "${aws_security_group.lustre-sg.id}",
	]
}
