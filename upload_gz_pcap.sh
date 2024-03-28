#!/bin/bash

# Set variables
BUCKET_NAME="public-project2021"
LOCATION_PATH="$1"
PID=$$
LOG_FILE="/tmp/pcap_upload.log"
UPLOADED_DIR="${LOCATION_PATH}/uploaded"

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Function to upload a .pcap file
upload_pcap() {
  local FILE_PATH="$1"
  local FILE_NAME="$(basename "$FILE_PATH")"

  # Upload the file to S3
  aws s3 cp "$FILE_PATH" "s3://$BUCKET_NAME/$FILE_NAME"

  # Log the uploaded file
  echo "$(date) - Uploaded $FILE_PATH to $BUCKET_NAME" >> "$LOG_FILE"

  # Move the file to the 'uploaded' directory
  mkdir -p "$UPLOADED_DIR"
  mv "$FILE_PATH" "$UPLOADED_DIR"
}

# Loop to check for new .pcap files every 2 minutes
while true; do
  for file in "$LOCATION_PATH"/*.gz; do
    if [ -e "$file" ]; then
        #if sudo lsof "$file" &> /dev/null; then
        echo "$$ : File $file is still being written to, skipping upload." >> "$LOG_FILE"
        #fi
    else
      upload_pcap "$file"
    fi
  done

  # Wait for 2 minutes
  sleep 120
done
