#!/usr/bin/env ruby
# Id$ nonnax 2022-02-01 17:32:25 +0800
require 'rubytools/time_and_date_ext'
inf=ARGV.first
# cmd="ffprobe -i '#{inf}' -sexagesimal -show_entries format=duration -v quiet -of csv='p=0'"
cmd="ffprobe -i '#{inf}' -show_entries format=duration -v quiet -of csv='p=0'"
puts (IO.popen(cmd, &:read).to_f*1000).to_ts
