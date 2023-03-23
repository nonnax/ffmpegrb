#!/usr/bin/env ruby
# Id$ nonnax 2023-03-21 15:52:19 +0800

f, = ARGV
iname=File.basename(f, '.*')
cmd=<<~___
 ffmpeg -r 1 -i #{f} -r 1 $#{iname}%05d.bmp
___

IO.popen(cmd, &:read)

puts 'done'
