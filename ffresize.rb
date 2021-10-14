#!/usr/bin/env ruby
# Id$ nonnax 2021-10-14 00:53:32 +0800
require 'fzf'
#To get a "visually lossless" quality, you can use:
#ffmpeg -i MyMovie.mkv -vf scale=-1:720 -c:v libx264 -crf 18 -preset veryslow -c:a copy MyMovie_720p.mkv
inf=Dir["*.m*"].fzf.first
size=%w[720p 1080p].fzf(cmd: %(fzf --prompt='dimension')).first
exit unless inf

cmd=[]
cmd<<"ffmpeg -i '#{inf}'"
cmd<<"-vf scale=-1:#{size}"
cmd<<'-c:v libx264 -crf 18 -preset veryslow -c:a copy'
cmd<<"#{size}-#{inf}"

IO.popen(cmd.join(' '), &:read)
