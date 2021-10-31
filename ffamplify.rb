#!/usr/bin/env ruby
# Id$ nonnax 2021-10-11 22:47:15 +0800
# Used with lf file manager file selections
require 'fzf'

text=[]

volume=(-5..5).map{|i| 
  "%ddB" % [i*5]
}.fzf(cmd: 'fzf --print-query --preview "echo {q}"').first

Dir['*.*']
  .fzf_preview('ffmpeg -hide_banner -nostats -i {} -af "volumedetect" -vn -sn -dn -f null /dev/null')
  .each  do |f|
  basename=f.split(%r(/)).last
  # p cmd="ffmpeg -i '#{f}' -vcodec copy -af 'volume=#{volume}'  '#{volume}-#{basename}'"
  # -b:a 192k
  # -b:v 1M
  # -vn

  cmd=<<~FFMPEG
    ffmpeg 
    -i '#{f}' 
    -filter:a 'volume=#{volume}'  
    -c:v copy
    'a_#{volume}_#{basename}'
  FFMPEG
  cmd.gsub!(/\n/,' ')
  IO.popen(cmd, &:read)
end
