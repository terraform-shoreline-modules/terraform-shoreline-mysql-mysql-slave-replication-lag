ping -c 3 $MASTER_SERVER > /dev/null 2>&1

if [ $? -eq 0 ]; then

    echo "Network connectivity between master and slave MySQL servers is OK."

else

    echo "Network connectivity between master and slave MySQL servers is not OK."

fi