#!/usr/bin/env ruby
# Id$ nonnax 2021-10-10 22:56:31 +0800

require 'fzf'

v=Dir['*.*'].fzf(cmd: %(fzf --prompt='video')).first
a=Dir['*.mp3'].fzf(cmd: %(fzf --prompt='audio')).first

cmd=<<~FFMPEG
	ffmpeg
	-i '#{v}'
	-i '#{a}'
	-map 0:0 -map 1:0
	-shortest
	'mix_#{v}_#{a}.mp4'
FFMPEG

cmd.gsub!(/\n/, ' ')

IO.popen(cmd, &:read)
