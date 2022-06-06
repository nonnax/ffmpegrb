#!/usr/bin/env ruby
# Id$ nonnax 2022-06-04 18:58:06 +0800
# ffmpeg -i in.mp4 -filter:v "crop=out_w:out_h:x:y" out.mp4
# 
# Where the options are as follows:
# 
    # out_w is the width of the output rectangle
    # out_h is the height of the output rectangle
    # x and y specify the left-top corner of the output rectangle
# 
f,=ARGV
p cmd="ffmpeg -i '#{f}' -filter:v 'crop=in_w/3:in_h:in_w/3:0' -preset veryslow 'crop_#{f}'"
IO.popen(cmd, &:read)
