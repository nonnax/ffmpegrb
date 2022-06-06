#!/usr/bin/env ruby
# Id$ nonnax 2021-10-11 16:14:52 +0800

# Use video from video.mkv. Mix audio from video.mkv and audio.m4a using the amerge filter:
# ffmpeg -i video.mkv -i audio.m4a -filter_complex "[0:a][1:a]amerge=inputs=2[a]" -map 0:v -map "[a]" -c:v copy -ac 2 -shortest output.mkv
require 'fzf'
require 'file_ext'

arr=[]

ENV['fs'].split("\n").map{|e|
  basename=File.basename(e)
  arr<<basename 
}

p part = arr.sort.partition{|e| e.match?(/^v/)}

exit unless arr


def add_bg(v, a)
  cmd=<<~FFMPEG 
    ffmpeg
    -i '#{v}'
    -i '#{a}'
    -filter_complex '[0:a][1:a]amix=inputs=2[a]'
    -map 0:v -map '[a]'
    -c:v copy
    -ac 2 
    -shortest
    vbg_#{v.to_safename}_#{a.to_safename}
  FFMPEG
  cmd.gsub!(/\n/, ' ')
  IO.popen(cmd, &:read) 
end


choice=%w[no yes].fzf(cmd: %(fzf --prompt="add background?")).first

part.transpose.each{|v, a|
  add_bg(v, a)
} if choice=='yes'

# cmd.gsub!(/\n/,' ')
# puts cmd.strip
