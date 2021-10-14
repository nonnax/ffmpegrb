#!/usr/bin/env ruby
# Id$ nonnax 2021-10-10 22:56:31 +0800

require 'fzf'
v=Dir['*.*'].fzf(cmd: %(fzf --prompt='video')).first
a=Dir['*.mp3'].fzf(cmd: %(fzf --prompt='audio')).first

cmd=[]
cmd<<"ffmpeg"
cmd<<"-i #{v}"
cmd<<"-i #{a}"
# cmd<<"-c copy -map 0:0 -map 1:0"
cmd<<"-map 0:0 -map 1:0"
cmd<<"#{v}#{a}.mp4"

IO.popen(cmd.join(' '), &:read)
