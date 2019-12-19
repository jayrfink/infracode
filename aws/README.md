Demonstration Code:

iam: Some sample groupings

us-east-segment:
 - various simple playbooks
 - an init script for ubuntu ami's
 - hosts for ansible
 - setenv for ansible hosts

us-east-segment/terra: 
- 1 VPC
- 1 public subnet
- 1 private subnet
- 1 igw 
- 1 natgw (for private subnet)
- 1 bastion instance
- 2 private instances

  NOTE: Of course you want to change the names of things in the terraform code
