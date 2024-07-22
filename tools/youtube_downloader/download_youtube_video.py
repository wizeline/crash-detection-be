# from pytube import YouTube

# # where to save. 
# # replce /home/balasundar/Downloads/ with the path where you want to store the dowload file
# destination = "/Users/cesar.reyes/Code/Wizeline/AI/nbcu-genai-poc/media"
# # link of the video to be downloaded
# # Replace with the Youtube video link you want to download.
# video_link = "https://www.youtube.com/watch?v=w9iwx9Ld0zs"

# try:
#     video = YouTube(video_link)
#     # filtering the audio. File extension can be mp4/webm
#     # You can see all the available streams by print(video.streams)
#     audio = video.streams.filter(only_audio=False, file_extension='mp4').first()
#     audio.download(destination)
#     print('Download Completed!')
    
# except:
#     print("Connection Error")  # to handle exception
    
import os
import sys
import argparse
# from pytube import YouTube
from pytubefix import YouTube
from pytubefix.cli import on_progress

def validate_path(path):
    if not os.path.isdir(path):
        raise argparse.ArgumentTypeError(f"The directory '{path}' does not exist.")
    return path

def validate_url(url):
    try:
        YouTube(url)
        # print(url)
    except Exception as e:
        raise argparse.ArgumentTypeError(f"The URL '{url}' is not a valid YouTube URL: {e}")
    return url

def download_video(url, path):
    try:
        yt = YouTube(url, on_progress_callback = on_progress)
        print(yt.title)
        stream = yt.streams.get_highest_resolution()
        # stream = yt.streams.filter(only_audio=False, file_extension='mp4').first()
        stream.download(output_path=path)
        print(f"Downloaded '{yt.title}' to '{path}'")
    except Exception as e:
        print(f"Failed to download video: {e}")

def main():
    parser = argparse.ArgumentParser(description="Download a YouTube video to a specified directory.")
    parser.add_argument('destination', type=validate_path, help="Path to the destination directory.")
    parser.add_argument('url', type=validate_url, help="YouTube video URL.")
    
    args = parser.parse_args()
    print(args)
    
    download_video(args.url, args.destination)

if __name__ == "__main__":
    main()