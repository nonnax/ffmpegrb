#!/usr/bin/env ruby
# Id$ nonnax 2023-03-23 22:57:31 +0800
def cmd
 ->(f, scale:360) do
 <<~___
 ffmpeg -i #{f} -vf "scale=-1:#{scale}, scale=trunc(iw/2)*2:#{scale}" out_#{File.basename(f, '.*')}.mp4
 ___
 end
end

f, scale = ARGV
puts IO.popen(cmd.call(f, scale:), &:read)
