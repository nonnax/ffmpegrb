#!/usr/bin/env ruby
# Id$ nonnax 2021-10-26 14:55:45 +0800
# require 'fzf'
# infs=Dir['*.*'].fzf(cmd: "fzf --preview='ffprobe {}' ")
f=ARGF.first
# p cmd="ffprobe '#{f}'"
cmd="ffmpeg -hide_banner -nostats -i '#{f}' -af volumedetect -vn -sn -dn -f null"
puts IO.popen(cmd, &:read)
# infs.each do |f|
	# IO.popen("ffprobe #{f}", &:read)
# end
