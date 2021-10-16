#!/usr/bin/env ruby
# Id$ nonnax 2021-10-11 15:34:53 +0800
# Used with lf file manager file selections
# ffmpeg -f concat -safe 0 -i concat.txt -c copy out-concat.mp4

text=[]

ENV["fs"].split("\n").each  do |f|
	text << %(file '#{f}')
end

IO.write( 'concat.txt', text.join("\n") )

cmd=<<~FFMPEG
	ffmpeg
	-f concat
	-safe 0
	-i concat.txt
	-c copy
	vcat_#{Time.now.to_i}.mp4
FFMPEG

cmd.gsub!(/\n/, ' ')

IO.popen(cmd, &:read)
