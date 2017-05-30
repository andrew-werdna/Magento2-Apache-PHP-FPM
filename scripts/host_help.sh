#!/bin/bash

function removeHost()
{
	# Hostname to add/remove.
	IP=$1
	HOST=$2
	
	if [ -n "$(grep "$IP\s$HOST" $ETC_HOSTS)" ]
		then
			echo "Removing $HOST from $ETC_HOSTS";
			sed -i".bak" "/$IP $HOST/d" $ETC_HOSTS
		else
			echo "$HOST was not found in $ETC_HOSTS";
	fi
}


function addHost()
{
	IP=$1
	HOST=$2
	
	if [ -n "$(grep "$IP\s$HOST" $ETC_HOSTS)" ]
		then
			echo "$HOST already exists in $ETC_HOSTS"
		else
			echo "Adding $IP $HOST to $ETC_HOSTS";
			echo $IP $HOST >> $ETC_HOSTS;

			if [ -n "$(grep "$IP\s$HOST" $ETC_HOSTS)" ]
				then
					echo "$IP $HOST was added succesfully";
				else
					echo "Failed to add $IP $HOST";
			fi
	fi
}

function addDockerHosts()
{
	addHost $1 $2
}

function removeDockerHosts()
{
	removeHost $1 $2
}
