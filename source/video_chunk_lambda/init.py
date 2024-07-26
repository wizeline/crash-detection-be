
import os
import boto3
import json
import logging
import botocore
import cv2
from helpers import get_secrets

secret_name = os.getenv("SECRETS_NAME")
secrets = get_secrets(secret_name)

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    print(event)
    
    try:
        logger = logging.getLogger()
        logger.setLevel(logging.INFO)
        logger.info('event parameter: {}'.format(event))
        tmp_file_path = "/tmp/video.mp4"

        s3 = boto3.resource('s3')
        BUCKET_NAME = event["BUCKET_NAME"]
        S3_KEY = event["S3_KEY"]

        BUCKET_UPLOAD_NAME = event["BUCKET_UPLOAD_NAME"]
        BUCKET_UPLOAD_S3_KEY = event["BUCKET_UPLOAD_S3_KEY"]

        try:
            s3.Bucket(BUCKET_NAME).download_file(S3_KEY, tmp_file_path)
        except botocore.exceptions.ClientError as e:
            if e.response['Error']['Code'] == "404":
                logger.info("The object does not exist: s3://" + BUCKET_NAME + S3_KEY)
            else:
                raise

        parts = chunk_video(video_file=tmp_file_path, logger=logger, s3=s3, bucket_name=BUCKET_UPLOAD_NAME, bucket_key=BUCKET_UPLOAD_S3_KEY)

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": f"Saved {parts} parts of {tmp_file_path} to s3://"+BUCKET_NAME+"/chunks/",
            }),
        }
    except Exception as e:
        print(f"An error occurred: {e}")
        return {
            'statusCode': 500,
            'body': 'Error'
        }
    
def chunk_video(video_file, logger, s3, bucket_name, bucket_key):

    # Ensure output directory exists
    chunks_path = "/tmp/chunks/"
    os.makedirs(chunks_path, exist_ok=True)
    chunk_seconds_duration = 3
    current_chunk = 1
    
    vc = cv2.VideoCapture()
    if not vc.open(video_file):
        logger.info('failed to open video capture')
        return

    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    # Match source video features.
    fps = vc.get(cv2.CAP_PROP_FPS)
    size = (
        int(vc.get(cv2.CAP_PROP_FRAME_WIDTH)),
        int(vc.get(cv2.CAP_PROP_FRAME_HEIGHT)),
    )

    vw = cv2.VideoWriter()
    file_name = f"{chunks_path}{video_file[:-4]}_part{current_chunk}.mp4"
    if not vw.open(file_name, fourcc, fps, size):
        logger.info('failed to open video writer')
        return
    
    i = 0
    while True:
        
        if i >= fps * chunk_seconds_duration:
            vw.release()
            #S3.Client.upload_file(Filename, Bucket, Key, ExtraArgs=None, Callback=None, Config=None)
            s3.upload_file('/tmp/{filename}',bucket_name, bucket_key)
            current_chunk += 1
            file_name = f"{chunks_path}{video_file[:-4]}_part{current_chunk}.mp4"
            logger.info(f"writing: {file_name}")
            vw = cv2.VideoWriter()
            if not vw.open(file_name, fourcc, fps, size):
                logger.info('failed to open video writer')
                return
            i = 0

        ok, frame = vc.read()
        if not ok:
            break
        i += 1
        # Write processed frame.
        vw.write(frame)

    vc.release()
    vw.release()
    cv2.destroyAllWindows()