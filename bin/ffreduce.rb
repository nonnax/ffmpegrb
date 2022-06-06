#!/usr/bin/env ruby
# Id$ nonnax 2021-10-31 10:41:19 +0800
require 'rubytools/fzf'
# 
trans_type = ARGV.first&.to_i || 2

inf = Dir['*.*'].fzf.first

cmd = []
cmd << 'ffmpeg'
cmd << "-i #{inf}"
cmd << "-vf fps=fps=20"
# cmd << "-b:v 800k"
cmd << '-maxrate 800k'
cmd << '-bufsize 2M'
cmd << "-c:v libx264"
cmd << '-crf 20' # -qscale 0"
cmd << "vsmall_#{inf}"

p cmd * ' '

IO.popen(cmd.join(' '), &:read)
