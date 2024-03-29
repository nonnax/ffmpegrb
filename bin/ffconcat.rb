#!/usr/bin/env ruby
# Id$ nonnax 2021-09-29 00:54:52 +0800
# ffmpeg -f concat -safe 0 -i concat.txt -c copy $of
# require 'rubytools/fzf'

# selected=Dir['*.*'].fzf
selected=ARGV

if selected.empty?
  puts __FILE__+" <file1> <file2> <file2> ..."
  exit
end
text=selected.map do |e|
   "file '#{e}'"
end

File.open('concat.txt', 'w'){|f| f.puts text.join("\n")}

cmd="ffmpeg -f concat -safe 0 -i concat.txt -crf 24 -c:v libx265 'vcat_#{selected.first}'"
IO.popen(cmd, &:read)

