Demonstration Code:

iam: Some sample groupings
common-tasks: Very basic playbooks for instances

./:
 - init_ubuntu.sh: Sets up python3->python symlink for ansible
 - hosts for ansible
 - setenv for ansible hosts

adrift-us-east-1
- 1 VPC
- 1 public subnet
- 1 private subnet
- 1 igw 
- 1 natgw (for private subnet)
- 1 bastion instance
- 2 private instances

  NOTE: To make customization easier, I put the word 
        "adrift" into all of the labels. 

        DO look at the network (subnet) CIDRs some are as restrictive as 
        AWS allows.
