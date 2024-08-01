import boto3
import yt_dlp
import os
import validators

from dotenv import load_dotenv 

load_dotenv()

target_bucket = os.getenv("TARGET_BUCKET")
download_folder = 'download'

yt_opts = { 'format':'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best', 
            'outtmpl': download_folder +'/%(id)s.mp4',
            'ignoreerrors': True,
            'cookiesfrombrowser':  ('chrome', ) 
        }

ydl = yt_dlp.YoutubeDL(yt_opts)

# Reads the video list
video_list_file = open("video_list.txt", "r") 
video_urls = video_list_file.read() 
video_list = video_urls.split("\n") 
video_list_file.close() 

# Downloads video if its a valid URL
for video_url in video_list:
    if validators.url(video_url):
        ydl.download(video_url) 

dir_list = os.listdir(download_folder)

#Upload all MP4 files from Downloads folder to S3
s3 = boto3.resource('s3')

for file in dir_list:
    if file.endswith(".mp4"):
        print("Uploading " + file)
        s3.Bucket(target_bucket).upload_file(download_folder + "/" + file, file)