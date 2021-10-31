#!/usr/bin/env ruby
# Id$ nonnax 2021-10-14 00:53:32 +0800
require 'fzf'
#To get a "visually lossless" quality, you can use:
#ffmpeg -i MyMovie.mkv -vf scale=-1:720 -c:v libx264 -crf 18 -preset veryslow -c:a copy MyMovie_720p.mkv
inf=Dir["*.m*"].fzf.first
size=['1280:720', '1920:1080'].fzf(cmd: %(fzf --prompt='dimension')).first
exit unless inf

cmd=[]
cmd <<"ffmpeg -i '#{inf}'"
cmd <<"-filter:v fps=25,scale=#{size}"
cmd <<'-c:v libx264'
cmd <<'-crf 20 -preset veryslow'
cmd <<'-c:a copy'
cmd <<'-pix_fmt yuv420p'
cmd <<'-movflags +faststart'
cmd<<"'#{size.split(':').last}-#{inf}'"
p cmd.join(' ')
IO.popen(cmd.join(' '), &:read)
