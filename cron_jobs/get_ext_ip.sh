#!/bin/bash

# TODO: Change from dropbox to.... mail? stud?
# TEST

# Bash script to get the external IP address
MYWANIP=$(curl http://mire.ipadsl.net | sed -nr -e 's|^.*<span class="ip">([0-9.]+)</span>.*$|\1| p')
echo "My IP address is: $MYWANIP"

IPold=$(cat /home/USER/Dropbox/test.txt)
echo "Previous IP Address: $IPold"

if [[ $IPold != $MYWANIP ]] ;
    then
        echo "New IP"
        rm /home/USER/Dropbox/test.txt
        echo $MYWANIP >> /home/USER/Dropbox/test.txt;
        echo $MYWANIP;
    else
      echo "Same IP";
fi

      # example crontab entry:
          ## m h  dom mon dow   command
              ## */10 * * * * /home/USER/Dropbox/test_ip.sh
