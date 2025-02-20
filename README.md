
## Ansible role to install a Drone (drone.io) server

This includes customizations for the cppalliance and boost.org environments. Thus, while anyone is welcome to use the ansible role as a reference it is not a plain Drone installation.  

## Instructions

Place the new drone server in the ansible group [drone-servers], and the previous drone server in the group [drone-original].

Execute the playbook drone-playbook.yml.  

Review the results by running `scripts/compare-files.sh` and `scripts/review-database.sh`.  
