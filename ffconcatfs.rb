#!/usr/bin/env ruby
# Id$ nonnax 2021-10-11 15:34:53 +0800
# Used with lf file manager file selections
# ffmpeg -f concat -safe 0 -i concat.txt -c copy out-concat.mp4

text=[]

# ENV["fs"].each_line do |f|
	# text<< %(file '#{f.chomp}')
# end

ENV["fs"].split("\n").each  do |f|
	text << %(file '#{f}')
end

IO.write( 'concat.txt', text.join("\n") )
cmd = []
cmd <<"ffmpeg"
cmd <<"-f concat"
cmd <<"-safe 0"
cmd <<"-i concat.txt"
cmd <<"-c copy"
# cmd <<"-avoid_negative_ts default"
cmd <<"-avoid_negative_ts make_zero"
cmd <<"out-concat.mp4"

IO.popen(cmd.join(' '), &:read)
