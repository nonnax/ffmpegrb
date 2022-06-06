#!/usr/bin/env ruby
# Id$ nonnax 2022-06-06 12:08:31 +0800
require 'mote'
# Here,# 
# we use the select filter to extract a frame if the expression in single-quotes evaluates to non-zero. 
# If the expression is zero, then select filter discards that frame.
#   mod(A,B) returns the modulus (remainder after division) result after dividing A by B. 
# So, if we divide 0 by 300, we get 0. Then, 1/300 is 1, and so on.
#   not inverts this result. So, if the modulus is zero, then the final result is 1. 
# If the modulus is non-zero, then the result is evaluated to zero.

# Based on this not operation, the select filter picks up a frame.
# 
# The sequence I am using has a frame-rate of 30 fps. And, I want a frame every 10 seconds. 
# So, I have to choose a frame out of every 300 frames, right?
#
# That is why I used select='not(mod(n,300))'
# 
# This gives me very accurate thumbnails as you can see in the image gallery below. 
# Click on the images to expand them and see the timestamps.

# Here is a simple one-liner that can take care of creating a thumbnail and resizing it for you.
# 
# ffmpeg -i input1080p.mp4 -r 1 -s 1280x720 -f image2 screenshot-%03d.jpg
# 
# The -r command sets the output frame rate (=1) and image2 is an image file muxer that is used to write video frames to image files. 
# Using the -s 1280x720 command, we can resize the video frames before writing them as images. Note, that the input video is a 1920x1080p video.
# 
# The above command will take a screenshot every 1 second. The screenshots would be named 001, 002, etc. because we have specified the formatting as %3d.
# 
# However, in my experience, I have found this technique to be not frame-accurate.
# Depending on your sequence’s frame-rate, you can modify the command line shown. If you don’t know your video’s frame-rate, you can use ffprobe to find out.
# 
# ffprobe -show_entries format=duration globe-with-timestamp.mp4
#  if video has 30 fps and I want a frame every 10 seconds. 
#  30fps*10sec then timeframe = 300
# 'min(320,iw)':'min(240,ih)'
params={
  video: 'video.mp4',
  fps: 60,
  per_second: 0.5,
  scale: '1280:360',
}

def get_frames(params)
  params[:timeframe] = params[:fps]*params[:per_second]
  @params = params
  cmd = %q(ffmpeg -i {{video}} -qscale:v 2 -vf "select='not(mod(n,{{timeframe}}))',setpts='N/({{fps}}*TB)',scale='{{scale}}'" -f image2 frames/frame_%04d.jpg 2>&1)

  @cmd = Mote.parse(cmd, self, params.keys)
  # pp IO.popen( t, &:readlines).select{|e| (/input|output|stream/i).match?(e) }
end
