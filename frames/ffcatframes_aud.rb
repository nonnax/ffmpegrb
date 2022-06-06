#!/usr/bin/env ruby
# Id$ nonnax 2022-06-06 13:11:40 +0800
require 'mote'

mp3, = ARGV

params={
  rate: 24,
  mp3: 
}

cmd="ffmpeg -r {{rate}} -i frames/frame_%04d.jpg -i '{{mp3}}' -c:v libx264 -c:a aac -pix_fmt yuv420p -crf 23 -r {{rate}} -shortest -y video_frames_aud.mp4 2>&1"

t=Mote.parse(cmd, self, params.keys)[params]

pp IO.popen(t, &:readlines).select{|e| (/input|output|stream/i).match?(e)}

