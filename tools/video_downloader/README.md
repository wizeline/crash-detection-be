# YouTube Video Downloader and other video platforms Documentation

## Overview
This Python script downloads a YouTube video list to a specified directory. It reads the destination directory path and the YouTube video URL from the command line, validates the inputs, downloads the video into the specified directory and uploads it to a S3 bucket specified in ```TARGET_BUCKET``` env var.

## Prerequisites
- boto3
- yt_dlp
- validators
- python-dotenv

## Installation

### Install Python
Ensure that Python 3.6 or higher is installed on your system. You can download it from the [official Python website](https://www.python.org/downloads/).

### Install dependencies
Install the requieremnts.txt ```pip install -r requirements.txt```

## Script Usage


### Running the Script
To run the script, use the following command format. Make sure you have a ```video_list.txt``` with all the videos URL you want to download on it.

```bash
python video_downloader.py
```

### Example
Download a YouTube video to a directory named `videos`:
```bash
python download_youtube_video.py ./videos "https://www.youtube.com/watch?v=abcdefghijk"
```

### Extra ffmpeg samples

#### Splitting a Video at Regular Time Intervals

```bash
ffmpeg -i /path/to/your/video.mp4 -acodec copy -f segment -segment_time 20 -vcodec copy -reset_timestamps 1 -map 0 output_time_%d.mp4
```
