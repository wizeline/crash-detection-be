import boto3
import json
import base64
from botocore.exceptions import ClientError

secrets_client = boto3.client('secretsmanager')

def get_secrets(secret_name):
    """
    Retrieve a secret from AWS Secrets Manager.
    
    This function uses the boto3 library to interact with AWS Secrets Manager.
    It retrieves a secret value by its name and decrypts it using the associated KMS CMK.
    If the secret is a binary type, it is decoded using base64.
    
    :param secret_name: str - Name of the secret to retrieve.
    :return: dict - Secret value if found, otherwise None.
    :raises: ClientError - If there is an error while interacting with AWS Secrets Manager.
    """
    
    try:
        # Get the secret value
        response = secrets_client.get_secret_value(SecretId=secret_name)
    except ClientError as e:
        if e.response['Error']['Code'] == 'ResourceNotFoundException':
            print("The requested secret " + secret_name + " was not found.")
        elif e.response['Error']['Code'] == 'InvalidRequestException':
            print("The request was invalid due to:", e)
        elif e.response['Error']['Code'] == 'InvalidParameterException':
            print("The request had invalid params:", e)
        else:
            print("Error occurred: ", e)
        return None
    # Decrypts secret using the associated KMS CMK
    # Depending on whether the secret is a string or binary, one of these fields will be populated
    if 'SecretString' in response:
        secret = response['SecretString']
    else:
        secret = base64.b64decode(response['SecretBinary'])
    
    return json.loads(secret)

