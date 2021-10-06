#!/bin/bash
latency=0.0
success=0
max=20
i=0
while [ $i -lt $max ]; do
	resp=`curl $1 -w %{time_total},%{http_code} --output /dev/null --silent`
	curr_latency="$(echo $resp | cut -d',' -f1)"
	status="$(echo $resp | cut -d',' -f2)"
	if [ "$status" -eq '200' ]
	then
	    success=$( echo "$success + 1" | bc)
	fi
	echo {$i}:$curr_latency,$status
	latency=$( echo "$latency + $curr_latency" | bc)
	i=$(($i+1))
done

AVG=$(echo "scale=2; $latency/$max" | bc)
echo "\n\nAverage Request Latency: $AVG"

if [ 1 -eq "$(echo "${AVG} < 2.00" | bc)" ]
then
   echo "Latency looks good!"
else
   echo "Rollout failed, hhigh latency in responses!"
   exit 1
fi

AVGRESP=`echo $(( $success * 5 ))`
echo "\n\nAverage Request Success Rate: $AVGRESP"

if [ "$AVGRESP" -gt '80' ]
then
    echo "Response Success Rate looks good!"
else
    echo "Rollout failed, non 200 responses observed!"
    exit 1
fi


