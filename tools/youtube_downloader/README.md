# YouTube Video Downloader Script Documentation

## Overview
This Python script downloads a YouTube video to a specified directory. It reads the destination directory path and the YouTube video URL from the command line, validates the inputs, and then downloads the video into the specified directory.

## Prerequisites
- Python 3.6 or higher
- `pytubefix` library

## Installation

### Install Python
Ensure that Python 3.6 or higher is installed on your system. You can download it from the [official Python website](https://www.python.org/downloads/).

### Install `pytubefix`
Install the `pytubefix` library using pip:
```bash
pip install pytubefix
```

## Script Usage


### Running the Script
To run the script, use the following command format:

```bash
python download_youtube_video.py /path/to/destination/directory "https://www.youtube.com/watch?v=example"
```

### Example
Download a YouTube video to a directory named `videos`:
```bash
python download_youtube_video.py ./videos "https://www.youtube.com/watch?v=abcdefghijk"
```

### Extra ffmpeg samplese

#### Splitting a Video at Regular Time Intervals

```bash
ffmpeg -i /path/to/your/video.mp4 -acodec copy -f segment -segment_time 20 -vcodec copy -reset_timestamps 1 -map 0 output_time_%d.mp4
```