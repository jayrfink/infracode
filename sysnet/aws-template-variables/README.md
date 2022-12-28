The idea here is to have a deployment template for sysadmins
who don't need to touch the VPC settings, so you provide them
with the variables information in the variables.tf (each var
needed is in all CAPS).

An example is if you have 2 vpcs. Copy this to two directories
as your base template. Then change variables.tf to match vpcA
in one and vpcB for the other. Now you have ec2 deployment 
templates for 2 vpcs and no one needs to know all the vpc 
details, they can copy from these new templates and just go...
