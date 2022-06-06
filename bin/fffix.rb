#!/usr/bin/env ruby
# Id$ nonnax 2021-10-26 13:45:56 +0800
require 'fzf'
infs=Dir['*.*'].fzf_preview('ffprobe {}')

infs.each do |f|
  cmd =  ['ffmpeg']
  cmd << '-err_detect ignore_err'
  cmd << "-i #{f}"
  cmd << '-c:v libx264'
  cmd << '-crf 20 -preset slow'
  cmd << '-pix_fmt yuv420p'
  cmd << '-movflags +faststart'
  cmd << "vfixed_#{f}"
  
  IO.popen(cmd.join(' '), &:read)
end
