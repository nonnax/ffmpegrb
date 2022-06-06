#!/usr/bin/env ruby
# Id$ nonnax 2022-06-04 19:11:22 +0800
f,=ARGV
cmd="ffmpeg -i #{f} -i #{f} -i #{f} -filter_complex hstack -preset slow 3x#{f}"

IO.popen(cmd, &:read)
