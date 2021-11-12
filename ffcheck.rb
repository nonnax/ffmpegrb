#!/usr/bin/env ruby
# Id$ nonnax 2021-10-26 14:55:45 +0800
require 'fzf'
infs=Dir['*.*'].fzf(cmd: "fzf --preview='ffprobe {}' ")

# infs.each do |f|
	# IO.popen("ffprobe #{f}", &:read)
# end
