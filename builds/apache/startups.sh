#!/bin/bash

/etc/init.d/apache2 start
wait
/etc/init.d/php7.0-fpm start
wait
echo -e "\n\napache & php7.0-fpm have started\n\n"

while /bin/true; do
  PROCESS_1_STATUS=$(ps aux |grep -q apache2 |grep -v grep)
  PROCESS_2_STATUS=$(ps aux |grep -q php7 | grep -v grep)
  # If the greps above find anything, they will exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit -1
  fi
  sleep 60
done