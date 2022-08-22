#!/usr/bin/env ruby
# Id$ nonnax 2022-08-21 23:29:43
# -video_size 1366x768
video_size='1092x614'
cmd=<<~___
ffmpeg
  -video_size #{video_size}
  -framerate 12
  -f x11grab
  -i :0.0+0,0
  -f pulse
  -i default
  -ac 2
  rec-01.mkv
___

cmd_str=cmd.split(/\s+/).join(' ')
IO.popen(cmd_str, &:read)
