#!/usr/bin/env ruby
# Id$ nonnax 2022-06-06 12:16:55 +0800
require 'mote'

params={
  rate:60,
  crf:20,
  mp4:'video_frames',
  scale: '1280:360'
  }

# cmd='ffmpeg -r {{rate}} -i frames/frame_%04d.jpg -c:v libx264 -pix_fmt yuv420p -crf {{crf}} -r {{rate}} -vf scale="{{scale}}"  -y {{mp4}}.mp4 2>&1'
cmd=File.read('frames.md').gsub(/\n/,' ').strip

p t=Mote.parse(cmd, self, params.keys)[params]

# pp IO.popen(t, &:readlines).select{|e| (/input|output|stream/i).match?(e) }
