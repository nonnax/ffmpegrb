#!/usr/bin/env ruby
# Id$ nonnax 2021-10-29 20:51:16 +0800
require 'fzf'
vid=Dir['*.*'].fzf(cmd: 'fzf --prompt "video"').first
aud=Dir['*.*'].fzf(cmd: 'fzf --prompt "audio"').first
# p cmd="ffmpeg -stream_loop -1 -i '#{vid}' -i '#{aud}' -c copy -shortest -fflags +shortest -max_interleave_delta 100M vmix_loop_output.mp4"
p cmd="ffmpeg -stream_loop -1 -i '#{aud}' -i '#{vid}' -map 1:0 -map 0:0 -c copy -shortest vmix_loop_output.mp4"
IO.popen(cmd, &:read)
