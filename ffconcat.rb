#!/usr/bin/env ruby
# Id$ nonnax 2021-09-29 00:54:52 +0800
# ffmpeg -f concat -safe 0 -i concat.txt -c copy $of
require 'fzf'

selected=Dir['*.*'].fzf

exit if selected.empty? 

text=selected.map do |e|
   "file '#{e}'"
end

File.open('concat.txt', 'w'){|f| f.puts text.join("\n")}

cmd="ffmpeg -f concat -safe 0 -i concat.txt -c copy out-concat.mp4"
IO.popen(cmd, &:read)
