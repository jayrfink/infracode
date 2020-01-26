resource "google_compute_network" "vpc_adrift" {
	name = "vpc-adrift"
	description = "adrift VPC"
	routing_mode = "REGIONAL"
}
