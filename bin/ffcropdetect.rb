#!/usr/bin/env ruby
# Id$ nonnax 2022-06-04 18:54:09 +0800
f,=ARGV
p cmd="ffmpeg -i '#{f}' -vf cropdetect -f null - 2>&1 | awk '/crop/ { print $NF }' | tail -1"

IO.popen(cmd, &:read)
