#!/usr/bin/env ruby
# Id$ nonnax 2021-11-09 14:54:23 +0800
require 'fzf'
require 'time_and_date'

vid=Dir["*.*"].fzf_prompt('video > ').first
img=Dir["*.*"].fzf_prompt('image > ').first
start=(1..0).fzf_query().first

cmd=<<~FFMPEG
  ffmpeg 
  -i '#{vid}'
  -i '#{img}'
  -filter_complex "[0:v][1:v] overlay=(W-w)-15:(H-h)/2:enable='between(t,#{start},20)'" 
  -pix_fmt yuv420p
  -c:a copy
  -c:v libx264
  -crf 22 -preset fast
  -pix_fmt yuv420p
  -movflags +faststart
  ovr_output_#{Time.now_sum}.mp4
FFMPEG
# -filter_complex "[0:v][1:v] overlay=(W-w)/2:(H-h)/2:enable='between(t,#{start},20)'"

cmd.gsub!(/\n{1,}/,' ')

IO.popen(cmd, &:read)
# W amd H are the base video's dimensions. And w and h the overlay video's.
