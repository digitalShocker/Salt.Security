#!/bin/bash

# Send TCP Dump PCAP files to S3
echo "Packet Capture script in action..."
LOG_LOCATION="/home/ec2-user"
exec > $LOG_LOCATION/run_tcpdump_log.txt 2>&1

# Get instance id
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id -H "X-aws-ec2-metadata-token: $TOKEN"`
echo $INSTANCE_ID

sudo mkdir /home/ec2-user/mnt/$INSTANCE_ID

while true :
do
  YEAR=$(date +%Y);
  MONTH=$(date +%m);
  DAY=$(date +%d);
  HOUR=$(date +%H);
  MINUTE=$(date +%M);

  # Capture PCAPs every 900 seconds
  # sudo tcpdump -i ens5 -s 0 -w /tmp/pcap_%H.%M.%S.pcap -G 60 -z gzip
  # sudo tcpdump -i ens5 -Z ec2-user -G 60 -w /home/ec2-user/mnt/$INSTANCE_ID/${YEAR}-${MONTH}-${DAY}-${HOUR}-${MINUTE}.pcap
  sudo tcpdump -i ens5 -s 0 -Z root -G 60 -w /home/ec2-user/mnt/$INSTANCE_ID/_%Y-%m-%d-%H.%M.%S.pcap
done
