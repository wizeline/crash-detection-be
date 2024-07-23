import av
import av.datasets

# Replace "/path/to/your/video.mp4" with the path to your video file
# It requred two layers, pillow and av libraries to work with this script in a AWS lambda function

content = av.datasets.curated("/path/to/your/video.mp4")
with av.open(content) as container:
    # Signal that we only want to look at keyframes.
    stream = container.streams.video[0]
    stream.codec_context.skip_frame = "NONKEY" # Skip non-keyframes.

    for frame in container.decode(stream):

        print(frame)

        # We use `frame.pts` as `frame.index` won't make must sense with the `skip_frame`.
        frame.to_image().save(
            "./frames/key_frame.{:04d}.jpg".format(frame.pts),
            quality=80,
        )
        
        