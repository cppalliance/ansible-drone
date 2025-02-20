#!/bin/bash
mkdir -p /opt/munin
autoscalers="autoscaler"
for autoscaler in $autoscalers; do
        grepper=$(docker ps -a | grep -P "\s+${autoscaler}$")
	if [ -n "$grepper" ]; then
	    echo "$autoscaler is running"
            /usr/bin/docker logs --tail 3000 $autoscaler 2>&1 | grep server-count | tail -n 1 | /usr/bin/jq '.["server-count"]' > /opt/munin/servercount.txt
	else
	    echo "$autoscaler is not running"
	    echo "0" > /opt/munin/servercount.txt
	fi
done

# /usr/bin/docker logs --tail 3000 autoscaler 2>&1 | grep server-count | tail -n 1 | /usr/bin/jq '.["server-count"]' > /opt/munin/servercount.txt
