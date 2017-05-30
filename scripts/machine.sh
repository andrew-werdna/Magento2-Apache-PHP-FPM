#/bin/bash

mflag=false
hflag=false
aflag=false

while getopts 'm:h:a:' flag; do

        case "${flag}" in
                m) VM="${OPTARG}" mflag=true ;;
                h) HOSTS="${OPTARG}" hflag=true ;;
				a) ACTION="${OPTARG}" aflag=true ;;
                :) echo "Missing option argument for" ;;
                *) error "Unexpected option ${flag}" ;;
        esac

done

if ! $mflag; then
  echo -e "\n\n-m {machine name} is a required argument\n\n";
  exit 1
fi

if ! $hflag; then
  echo -e "\n\n-h {host name} is a required argument\n\n";
  exit 1
fi

if ! $aflag; then
  echo -e "\n\n-a {action name} is a required argument\n\n";
  exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $DIR/host_help.sh
found=$(docker-machine ls | grep $VM);
ETC_HOSTS='/c/Windows/System32/drivers/etc/hosts'

case "$ACTION" in

	start)

		if [ -z "$found" ]
		then
			echo -e "\n\n$VM does not exist!\n\n";
			exit 0;
		fi

		docker-machine start $VM;
		wait

		yes | docker-machine regenerate-certs $VM;
		wait

		IP=$(docker-machine ip $VM)
		addDockerHosts $IP $HOSTS
		wait

		echo -e "\n\nPlease enter eval \`docker-machine env $VM\`\n\n";
		exit 0;
		;;

	stop)

		if [ -z "$found" ]
		then
			echo -e "\n\n$VM does not exist!\n\n";
			exit 0;
		else
			IP=$(docker-machine ip $VM)
			removeDockerHosts $IP $HOSTS
			wait
			docker-machine stop $VM;
			wait
			echo -e "\n\nDONE\n\n";
			exit 0;
		fi
		;;

	create)

		if [ -z "$found" ]
		then
			docker-machine create -d virtualbox $VM;
			wait
			IP=$(docker-machine ip $VM)
			addDockerHosts $IP $HOSTS
			wait
			echo -e "\n\nPlease enter eval \`docker-machine env $VM\`\n\n";
			exit 0;
		else
			echo -e "\n\n$VM already exists!\n\n";
			exit 0;
		fi
		;;

	destroy)

		if [ -z "$found" ]
		then
			echo -e "\n\n$VM does not exist!\n\n";
			exit 0;
		else
			IP=$(docker-machine ip $VM)
			removeDockerHosts $IP $HOSTS
			wait
			yes | docker-machine rm $VM;
			wait
			echo -e "\n\nDONE\n\n";
			exit 0;
		fi

esac
