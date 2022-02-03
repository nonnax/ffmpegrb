#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-10-06 19:09:52 +0800
# require 'fzf'
puts <<~___
ffrotate.rb <file><rotate_type>
# default 2
# 0 = 90CounterCLockwise and Vertical Flip (default)
# 1 = 90Clockwise
# 2 = 90CounterClockwise
# 3 = 90Clockwise and Vertical Flip
___
# or
# 
# ffmpeg -i in.mp4 -vf 'rotate=-PI/2' out.mp4
# cmd<<"-vf 'transpose=#{trans_type}'"
# -qscale
inf, trans_type = ARGV
trans_type ||= 2

cmd=<<~___
  ffmpeg
  -i #{inf}
  -vf 'rotate=-PI/2'
  -crf 22
  -c:a copy  
  vrot-#{inf}
___
cmd.gsub!(/\n+/,' ')

IO.popen(cmd, &:read)
