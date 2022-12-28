variable "secgrp-adrfit-ssh" {
	description = "SSH Inbound"
	type = string
	default = "SECGRPID" // set this to sg-xxxxxxxx
}

variable "secgrp-adrfit-egress" {
	description = "Egress Outbound"
	type = string
	default = "SECGRPID" // set this to sg-xxxxxxxx
}

# Optional and here for reference
variable "secgrp-adrfit-https" {
	description = "HTTPS Inbound"
	type = string
	default = "SECGRPID" // set this to sg-xxxxxxxx
}

# Do not change this unless we somehow are out of addresses
variable "net-adrfit" {
	description = "Subnet"
	type = string
	default = "SUBNETID" // set this to subnet-xxxxxxxx
}

# This has to match the subnet az
variable "avail-zone" {
	description = "Availability zone"
	type = string
	default = "us-east-1a"
}
