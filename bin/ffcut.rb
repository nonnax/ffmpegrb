#!/usr/bin/env ruby
# Id$ nonnax 2022-06-05 00:44:22 +0800
f, start, to = ARGV
p [File.basename(__FILE__), '<ss>', '<to>'].join(' ')

p cmd="ffmpeg -i #{f} -ss #{start} -to #{to} -c copy cut_#{f}"

IO.popen(cmd, &:read) if [f, start, to].all?
