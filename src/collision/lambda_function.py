import boto3
import json
import os
import sys

from aws_lambda_powertools import Logger
s3_client = boto3.client('s3')

logger = Logger()
logger.setLevel("INFO")

def handler(event, context):
    logger.info(">> Received event: " + json.dumps(event, indent=2))    
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        logger.info(f"Event : Bucket: {bucket}, Key: {key}")
        
        # List the contents of the bucket
        list_bucket_contents(bucket)
   
    return "OK"

def list_bucket_contents(bucket_name):
    logger.info(f'--- Content of bucket: {bucket_name} -------------')
    try:
        response = s3_client.list_objects_v2(Bucket=bucket_name)
        if 'Contents' in response:
            for obj in response['Contents']:
                logger.info(f"Key: {obj['Key']}, Size: {obj['Size']} bytes")
        else:
            logger.info(f"No objects found in bucket {bucket_name}")
    except Exception as e:
        logger.info(f"Error listing bucket contents: {e}")
    
    
if __name__ == "__main__":
    with open(sys.argv[1], 'r') as f:
        event = json.load(f)
    handler(event, "")        