In order to use these:

- Pass in variables as needed, these are mostly explained in the playbooks
- ansible-playbook --private-key=../.keys/$keyfile.pem (or wherever) \
		--limit $hostgroup -u [centos|ec2-user|ubuntu|redhat] adduser.yml
- Once your username has been added and keys set up:
   ansible-playbook [-u remote_username ] -e "hostgroup=www" selinuxoff.yml
  .... etc .....
