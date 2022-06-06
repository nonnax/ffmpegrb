#!/usr/bin/env ruby
# Id$ nonnax 2021-10-11 22:47:15 +0800
# Used with lf file manager file selections
require 'rubytools/file_ext'
f, db_vol=ARGV
exit unless [f, db_vol].all?

basename=File.basename(f)

db="%.1f" % [db_vol.to_f].map{|x| x.zero? ? 0 : (1-x)-1}
p [f, db_vol, db].join('->')
  
cmd=<<~___
  ffmpeg
  -hide_banner 
  -nostats
  -i '#{f}'
  -filter:a 'volume=#{db}dB'
  -c:v copy
  'a_#{db}_#{basename.to_safename}'
___
cmd.gsub!(/\n/,' ')

IO.popen(cmd, &:read)
