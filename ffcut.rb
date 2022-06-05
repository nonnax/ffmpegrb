#!/usr/bin/env ruby
# Id$ nonnax 2022-06-05 00:44:22 +0800
f, start, to = ARGV
p cmd="ffmpeg -i #{f} -ss #{start} -to #{to} -c copy cut_#{f}"
IO.popen(cmd, &:read)
