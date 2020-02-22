In order to use these:

- Change variables to match your needs
- ansible-playbook --private-key=../.keys/$keyfile.pem  \
		--limit $hostgroup -u [centos|ec2-user|ubuntu|redhat] adduser.yml
- Once your username has been added and keys set up:
   ansible-playbook [--limit $hostgroup] selinuxoff.yml
  .... etc .....
