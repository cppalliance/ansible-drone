
## Ansible role to install a Drone (drone.io) server

This includes customizations for the cppalliance and boost.org environments. Thus, while anyone is welcome to use the ansible role as a reference it is not a plain Drone installation.  

## Instructions

Place the new drone server in the ansible group [drone-servers], and the previous drone server in the group [drone-original].

Execute the playbook drone-playbook.yml.  

Review the results by running `scripts/compare-files.sh` and `scripts/review-database.sh`.  

## Monitoring

The other ansible roles which the Alliance uses have certain monitoring alerts configured for Drone.  

### Nagios:  

In host_vars for the server modify nrpe_checks and nagios_install_drone_plugin. (example values)   

```
nagios_install_drone_plugin: true
nrpe_checks:
  check_drone_autoscaler_queues:
    command: "{{ nrpe_plugin_dir }}/check_drone_autoscaler_queues"
    warning_condition: "250"
    critical_condition: "260"
```

In all nagios commands:  


```
commands: - {name: 'check_drone_autoscaler_queues', command: '$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_drone_autoscaler_queues'}
```

In all nagios host groups add a group:  
```
nagios_host_groups:
  - name: 'drone-server-monitoring'
    checks: 
      - {command: 'check_drone_autoscaler_queues', description: 'Check Drone Autoscaler Queue'}
```

In /etc/ansible/hosts:  

```
[drone-server-monitoring]
drone.cpp.al
```

### Munin: 

This drone role is installing /opt/drone/scripts/servercountv2.sh and cron jobs to run it each minute. Additionally munin plugins such as:  

```
/etc/munin/plugins/servercount-autoscaler-aws-arm
/etc/munin/plugins/servercount-autoscaler-aws-x86
/etc/munin/plugins/servercount-autoscaler-gce-arm
/etc/munin/plugins/servercount-autoscaler-gce-x86
/etc/munin/plugins/servercount-autoscaler-hetzner-arm
/etc/munin/plugins/servercount-autoscaler-hetzner-x86
```

Add the drone server to the host group `db-monitoring`. In the file /etc/ansible/group_vars/db-monitoring check that `munin_node_plugins` has multiple pg checks:  

```
munin_node_plugins:
  - name: postgres_autovacuum
    plugin: postgres_autovacuum
  - name: postgres_bgwriter
    plugin: postgres_bgwriter
  ...
```

The munin role automatically picks up that variable.  

In conclusion, on the topic of monitoring, the role `cppalliance.drone` installs some munin plugins, while some tasks are outsourced to the munin role. The nagios functionality is mostly taken care of by the nagios role rather than here. Check all monitoring and alerts after a new server install.   

 
