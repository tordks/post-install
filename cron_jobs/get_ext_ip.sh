#!/bin/bash


echo 'TEST' >> testtest.txt

# Bash script to get the external IP address
MYWANIP=$(curl http://mire.ipadsl.net | sed -nr -e 's|^.*<span class="ip">([0-9.]+)</span>.*$|\1| p')
echo "My IP address is: $MYWANIP"

IPold=$(cat /home/$USER/div/ip.txt)
echo "Previous IP Address: $IPold"

if [[ $IPold != $MYWANIP ]] ;
    then
        echo "New IP"
        rm /home/$USER/div/ip.txt
        echo $MYWANIP >> /home/$USER/div/ip.txt
        echo "$MYWANIP    $(date '+| %S:%M:%H | %d.%m.%y ')" >> /home/$USER/div/ip_statistic.txt
        echo $MYWANIP;

        cat div/ip.txt | mail -s "new ip" tordks@hotmail.com
    else
      echo "Same IP";
fi

      # example crontab entry:
          ## m h  dom mon dow   command
              ## */10 * * * * /home/$USER/Dropbox/test_ip.sh
