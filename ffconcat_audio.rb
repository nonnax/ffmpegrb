#!/usr/bin/env ruby
# Id$ nonnax 2021-10-16 11:53:57 +0800
# ffmpeg -i "concat:a.mp3|b.mp3" -c copy output.mp3

require 'fzf'

files=Dir["*.mp3"].fzf

cmd=<<~FFMPEG
	ffmpeg
	-i 'concat:#{files.join("|")}'
	-c copy
	acat.mp3
FFMPEG

IO.popen(cmd, &:read)
