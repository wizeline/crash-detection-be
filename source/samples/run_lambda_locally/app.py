import boto3
import json
import os

s3_client = boto3.client('s3')
target_bucket = os.getenv("TARGET_BUCKET")

def lambda_handler(event, context):
    print("------")
    print(f"Env var: {target_bucket}")
    print("------")
    print("Received event: " + json.dumps(event, indent=2))
    print("------")
    
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        print(f"Event : Bucket: {bucket}, Key: {key}")
        
        # List the contents of the bucket
        list_bucket_contents(target_bucket)
   
    return "OK"

def list_bucket_contents(bucket_name):
    print(f'--- Content of bucket: {bucket_name} -------------')
    try:
        response = s3_client.list_objects_v2(Bucket=bucket_name)
        if 'Contents' in response:
            for obj in response['Contents']:
                print(f"Key: {obj['Key']}, Size: {obj['Size']} bytes")
        else:
            print(f"No objects found in bucket {bucket_name}")
    except Exception as e:
        print(f"Error listing bucket contents: {e}")
    print('----------------')    