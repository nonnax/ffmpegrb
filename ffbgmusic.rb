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
cmd<< "ffmpeg"
cmd<< "-i '#{v}'"
cmd<< "-i '#{a}'"
# cmd<< "-filter_complex '[0:a][1:a]amerge=inputs=2[a]'"
cmd<< "-filter_complex '[0:a][1:a]amix=inputs=2[a]'"
cmd<< "-map 0:v -map '[a]'"
cmd<< '-c:v copy -ac 2 -shortest'
cmd<< "#{a_sane}_#{v_sane}"
p cmd * ' '
IO.popen(cmd.join(' '), &:read)
