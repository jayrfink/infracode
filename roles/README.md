To set the inventory:

export ANSIBLE_INVENTORY="path_to_inventory"

or use -i path_to_inventory

 Use  --private-key or --key-file. I have these in the .keys/ directory
 per type (aws/.keys and gcp/.keys) obviously the ones there now are
 empty...

Standard Variables for adrift playbooks:
hostgroups - so we can pass host groups in as a list. 
username - user to add
rusername - remote user to run as
