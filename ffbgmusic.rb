#!/usr/bin/env ruby
# Id$ nonnax 2021-10-11 16:14:52 +0800

# Use video from video.mkv. Mix audio from video.mkv and audio.m4a using the amerge filter:
# ffmpeg -i video.mkv -i audio.m4a -filter_complex "[0:a][1:a]amerge=inputs=2[a]" -map 0:v -map "[a]" -c:v copy -ac 2 -shortest output.mkv
require 'fzf'

v=Dir["*.*"].fzf(cmd: "fzf --prompt='video'").first
a=Dir["*.mp3"].fzf(cmd: "fzf --prompt='mp3'").first

exit unless v && a

v_sane = v.gsub(/[^\w\d.]/, '_')
a_sane = a.gsub(/[^\w\d.]/, '_')


cmd=[]
cmd=<<~FFMPEG 
	ffmpeg
	-i '#{v}'
	-i '#{a}'
	-filter_complex '[0:a][1:a]amix=inputs=2[a]'
	-map 0:v -map '[a]'
	-c:v copy
  -ac 2 
  -shortest
	vbg_#{a_sane}_#{v_sane}
FFMPEG

cmd.gsub!(/\n/,' ')
# puts cmd.strip
choice=%w[yes no].fzf(cmd: %(fzf --prompt="#{cmd}")).first
IO.popen(cmd, &:read) if choice=='yes'
