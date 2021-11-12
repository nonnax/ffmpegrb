#!/usr/bin/env ruby
# Id$ nonnax 2021-10-11 22:47:15 +0800
# Used with lf file manager file selections
require 'fzf'
require 'file_ext'

text=[]
ffprobe='ffmpeg -hide_banner -nostats -i {} -af "volumedetect" -vn -sn -dn -f null /dev/null'
Dir['*.*']
  .fzf_preview(ffprobe)
  .each  do |f|
  basename=File.basename(f)

  volume=(-5..5).map{|i| 
    "%d" % [i*5]
  }.fzf(cmd: "fzf --print-query --preview 'ffvolume_detect #{basename} && echo {q}'").first


  # p cmd="ffmpeg -i '#{f}' -vcodec copy -af 'volume=#{volume}'  '#{volume}-#{basename}'"
  # -b:a 192k
  # -b:v 1M
  # -vn

  cmd=<<~FFMPEG
    ffmpeg 
    -i '#{f}' 
    -filter:a 'volume=#{volume}dB'  
    -c:v copy
    'a_#{volume}_#{basename.to_safename}'
  FFMPEG
  cmd.gsub!(/\n/,' ')
  IO.popen(cmd, &:read)
end
