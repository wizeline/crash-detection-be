import boto3
import json
import os
import sys
import botocore
import cv2

from aws_lambda_powertools import Logger


logger = Logger()
logger.setLevel("INFO")
s3_client = boto3.client('s3')
target_bucket = os.getenv("CHUNKS_BUCKET")

def handler(event, context):
     logger.info('>> Event parameter: {}'.format(event))
     logger.info('target_bucket' + target_bucket)
     return 'Hello from AWS Lambda using Python' + sys.version + '!'

#     try:
        
#         logger.info('event parameter: {}'.format(event))
        
#         for record in event['Records']:
#             bucket = record['s3']['bucket']['name']
#             key = record['s3']['object']['key']
#             logger.info(f"Event : Bucket: {bucket}, Key: {key}")
        
#         tmp_file_path = "/tmp/video.mp4"
#         try:
#             s3.Bucket(bucket).download_file(key, tmp_file_path)
#         except botocore.exceptions.ClientError as e:
#             if e.response['Error']['Code'] == "404":
#                 logger.info("The object does not exist: s3://" + bucket + + "/" + key)
#             else:
#                 raise

#         parts = chunk_video(video_file=tmp_file_path, logger=logger, s3=s3, bucket_name=BUCKET_UPLOAD_NAME, bucket_key=BUCKET_UPLOAD_S3_KEY)

#         return {
#             "statusCode": 200,
#             "body": json.dumps({
#                 "message": f"Saved {parts} parts of {tmp_file_path} to s3://"+BUCKET_NAME+"/chunks/",
#             }),
#         }
#     except Exception as e:
#         logger.error(f"An error occurred: {e}")
#         return {
#             'statusCode': 500,
#             'body': 'Error'
#         }
    
# def chunk_video(video_file, logger, s3, bucket_name, bucket_key):

#     # Ensure output directory exists
#     chunks_path = "/tmp/chunks/"
#     os.makedirs(chunks_path, exist_ok=True)
#     chunk_seconds_duration = 10
#     current_chunk = 1
    
#     vc = cv2.VideoCapture()
#     if not vc.open(video_file):
#         logger.info('failed to open video capture')
#         return

#     fourcc = cv2.VideoWriter_fourcc(*'mp4v')
#     # Match source video features.
#     fps = vc.get(cv2.CAP_PROP_FPS)
#     size = (
#         int(vc.get(cv2.CAP_PROP_FRAME_WIDTH)),
#         int(vc.get(cv2.CAP_PROP_FRAME_HEIGHT)),
#     )

#     vw = cv2.VideoWriter()
#     file_name = f"{chunks_path}{video_file[:-4]}_part{current_chunk}.mp4"
#     if not vw.open(file_name, fourcc, fps, size):
#         logger.info('failed to open video writer')
#         return
    
#     i = 0
#     while True:
        
#         if i >= fps * chunk_seconds_duration:
#             vw.release()
#             #S3.Client.upload_file(Filename, Bucket, Key, ExtraArgs=None, Callback=None, Config=None)
#             s3.upload_file('/tmp/{filename}',bucket_name, bucket_key)
#             current_chunk += 1
#             file_name = f"{chunks_path}{video_file[:-4]}_part{current_chunk}.mp4"
#             logger.info(f"writing: {file_name}")
#             vw = cv2.VideoWriter()
#             if not vw.open(file_name, fourcc, fps, size):
#                 logger.info('failed to open video writer')
#                 return
#             i = 0

#         ok, frame = vc.read()
#         if not ok:
#             break
#         i += 1
#         # Write processed frame.
#         vw.write(frame)

#     vc.release()
#     vw.release()
#     cv2.destroyAllWindows()   
    
if __name__ == "__main__":
    with open(sys.argv[1], 'r') as f:
        event = json.load(f)
    handler(event, "")        