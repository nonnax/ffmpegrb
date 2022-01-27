#!/usr/bin/env ruby
# Id$ nonnax 2021-10-11 22:47:15 +0800
# Used with lf file manager file selections
require 'rubytools/file_ext'
# f, db_vol=ARGV
# exit unless [f, db_vol].all?
ARGF.each_line do |l|
  l=l.chomp
  f, db_vol=l.split(/\t/)
  basename=File.basename(f)

  db="%.1f" % [db_vol.to_f*1+1+1]
  # p [db, db_vol]
  p [f, db_vol]  
  cmd=<<~___
    ffmpeg
    -i '#{f}'
    -filter:a 'volume=#{db}dB'
    -c:v copy
    'a_#{db}_#{basename.to_safename}'
  ___
  cmd.gsub!(/\n/,' ')
  p cmd
  IO.popen(cmd, &:read)
end
