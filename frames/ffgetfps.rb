#!/usr/bin/env ruby
# Id$ nonnax 2022-06-06 12:20:29 +0800
f,=ARGV

info=IO.popen "ffprobe -show_entries format=duration #{f} 2>&1", &:readlines

puts info.select{|e| /Stream/.match?(e)}.map(&:strip).join("\n")
