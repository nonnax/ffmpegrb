#!/usr/bin/env ruby
# Id$ nonnax 2022-01-26 22:09:14 +0800

require 'json'

f=ARGV.first
cmd=<<~___
  ffprobe
  -hide_banner 
  -show_format 
  -print_format json
  #{f}
  2>1
___
cmd.gsub!(/\n/, ' ')
puts JSON.pretty_generate JSON.parse(IO.popen(cmd, &:read))
