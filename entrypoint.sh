#!/bin/bash
sleep 1

cd /home/container

# Replace Startup Variables
export STARTUP="./startup"
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
chmod +x /home/container/startup
${MODIFIED_STARTUP}
