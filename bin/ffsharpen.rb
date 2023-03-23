#!/usr/bin/env ruby
# Id$ nonnax 2023-03-21 15:52:19 +0800

# unsharp
#
# Sharpen or blur the input video.
#
# It accepts the following parameters:
#
# 'luma_msize_x, lx'
#
# Set the luma matrix horizontal size. It must be an odd integer between 3 and 23. The default value is 5.
# 'luma_msize_y, ly'
#
# Set the luma matrix vertical size. It must be an odd integer between 3 and 23. The default value is 5.
# 'luma_amount, la'
#
# Set the luma effect strength. It must be a floating point number, reasonable values lay between -1.5 and 1.5.
#
# Negative values will blur the input video, while positive values will sharpen it, a value of zero will disable the effect.
#
# Default value is 1.0.
# 'chroma_msize_x, cx'
#
# Set the chroma matrix horizontal size. It must be an odd integer between 3 and 23. The default value is 5.
# 'chroma_msize_y, cy'
#
# Set the chroma matrix vertical size. It must be an odd integer between 3 and 23. The default value is 5.
# 'chroma_amount, ca'
#
# Set the chroma effect strength. It must be a floating point number, reasonable values lay between -1.5 and 1.5.
#
# Negative values will blur the input video, while positive values will sharpen it, a value of zero will disable the effect.
#
# Default value is 0.0.
#
# All parameters are optional and default to the equivalent of the string '5:5:1.0:5:5:0.0'.
# Command line examples
#
# Apply strong luma sharpen effect:
#
# unsharp=luma_msize_x=7:luma_msize_y=7:luma_amount=2.5
#
# Apply a strong blur of both luma and chroma parameters:
#
# unsharp=7:7:-2:7:7:-2
# ffmpeg -i #{f} -vf unsharp=lx=3,ly=3,la=1.5 "sharp_#{f}"
# or
# ffmpeg -i #{f} -vf unsharp=3:3:1.5 "sharp_#{f}"
# -c:v libx264 -preset slow -crf 22
f, = ARGV
iname=File.basename(f, '.*')
outf="sharp_#{f}"
cmd=<<~___
  ffmpeg -i #{f} -vf unsharp=3:3:1.5 -preset slow -crf 19 "sharp_#{f}"
___

IO.popen(cmd, &:read)

puts outf

