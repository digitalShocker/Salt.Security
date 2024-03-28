#!/bin/bash
#
echo "FIleUpdate"
LOG_LOCATION="/home/ec2-user"
exec > $LOG_LOCATION/fileUpdate.log 2>&1

echo `/usr/bin/aws s3 rm s3://saltsecurity2024/file_list.json`
echo `/usr/bin/bash /usr/bin/python3 /home/ec2-user/fileGen.py`
