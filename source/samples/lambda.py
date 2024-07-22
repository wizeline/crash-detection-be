
import os
from helpers import get_secrets

secret_name = os.getenv("SECRETS_NAME")
secrets = get_secrets(secret_name)

def lambda_handler(event, context):
    print(event)
    print(secrets)
    
    return {
        'statusCode': 200,
        'body': 'OK'
    }