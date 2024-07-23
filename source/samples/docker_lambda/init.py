
import os
import boto3
from helpers import get_secrets

secret_name = os.getenv("SECRETS_NAME")
secrets = get_secrets(secret_name)

s3 = boto3.client('s3')

def lambda_handler(event, context):
    print(event)
    
    try:
        """
        WRITING THIS FUNCTION TO DOWNLOAD THE VIDEO FILE FROM S3 AND CONVERT IT TO
        """

        print("Done!")
        return {
            'statusCode': 200,
            'body': 'OK'
        }
    except Exception as e:
        print(f"An error occurred: {e}")
        return {
            'statusCode': 500,
            'body': 'Error'
        }