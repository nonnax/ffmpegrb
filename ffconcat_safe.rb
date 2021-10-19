#!/usr/bin/env ruby
# Id$ nonnax 2021-09-29 00:54:52 +0800
# ffmpeg -f concat -safe 0 -i concat.txt -c copy $of
require 'fzf'
require 'time_and_date'

files=ENV['fs'].split(/\n/)

exit if files.empty? 

in_files=files.take(2).inject([]){|a, f|
	a<<"-i '#{f}'"
}

cmd=<<~FFMPEG
	ffmpeg 
	#{in_files.join(' ')}
	-filter_complex
	"[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1 [v] [a]"
	-map [v] -map [a] -y 
	vcat_filter#{Time.timesum}.mp4
FFMPEG

cmd.gsub!(/\n/, ' ')

IO.popen(cmd, &:read)
