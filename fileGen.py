import boto3
import json

# Configure your AWS details
BUCKET_NAME = 'saltsecurity2024'  # Your S3 Bucket name
REGION_NAME = 'us-east-1'  # Your AWS Region
OUTPUT_FILE = '/home/ec2-user/mnt/file_list.json'  # Output file

# Initialize a session using Amazon S3
session = boto3.session.Session(region_name=REGION_NAME)
s3 = session.resource('s3')

# Function to list all files in the bucket
def list_files(bucket_name):
    bucket = s3.Bucket(bucket_name)
    file_list = []
    for obj in bucket.objects.all():
        file_list.append(obj.key)
    return file_list

# Generate the file list
files = list_files(BUCKET_NAME)

# Save the file list to a JSON file
with open(OUTPUT_FILE, 'w') as f:
    json.dump(files, f)
