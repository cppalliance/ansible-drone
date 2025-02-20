#!/bin/bash
mkdir -p /opt/munin
autoscalers="autoscaler-aws-x86 autoscaler-aws-arm autoscaler-gce-x86 autoscaler-gce-arm autoscaler-hetzner-x86 autoscaler-hetzner-arm"
for autoscaler in $autoscalers; do
        grepper=$(docker ps -a | grep -P "\s+${autoscaler}$")
        if [ -n "$grepper" ]; then
	    echo "$autoscaler is running"
            /usr/bin/docker logs --tail 3000 $autoscaler 2>&1 | grep server-count | tail -n 1 | /usr/bin/jq '.["server-count"]' > /opt/munin/servercount-$autoscaler
	else
	    echo "$autoscaler is not running"
	    echo "0" > /opt/munin/servercount-$autoscaler
	fi
done
