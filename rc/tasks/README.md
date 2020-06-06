In order to use these:

- Pass in variables as needed, these are mostly explained in the playbooks
- ansible-playbook --private-key=../.keys/$keyfile.pem (or wherever) \
		 -u [centos|ec2-user|ubuntu|redhat] -e "hostgroups=foo" useradd.yml
- Once your username has been added, sudo and keys set up or use
  -u [ec2-user|centos|redhat|ubuntu...]
   ansible-playbook -e "hostgroup=www" playbook.yml
  .... etc .....
