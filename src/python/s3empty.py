#!/usr/bin/python3
import boto3

BUCKET = 'YOUR-BUCKET-NAME'

s3 = boto3.resource('s3')
bucket = s3.Bucket(BUCKET)
bucket.object_versions.delete()

# if you want to delete the now-empty bucket as well, uncomment this line:
#bucket.delete()
