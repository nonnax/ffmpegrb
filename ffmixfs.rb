#!/usr/bin/env ruby
# Id$ nonnax 2021-10-10 22:56:31 +0800
# Used with lf file manager file selections
#	merges video and audio selections. 
# file selections are sequential pairs of vxx.mp4 and axxx.mp3, prefix with (v) and (a)

def combine(v, a)
  cmd=<<~FFMPEG
    ffmpeg
    -i '#{v}'
    -i '#{a}'
    -c copy -map 0:0 -map 1:0
    -shortest
    'vmix_#{v}_#{a}.mp4'
  FFMPEG
  cmd.gsub!(/\n/, ' ')
  IO.popen(cmd, &:read)
end

a=[]

ENV['fs'].split("\n").map{|e|
  basename=e.split(%r[/]).last
  a<<basename 
}

part = a.sort.partition{|e| e.match(/^v/)}

part.transpose.each{|v, a|
  combine(v, a)
}

