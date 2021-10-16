#!/usr/bin/env ruby
# Id$ nonnax 2021-10-13 20:38:45 +0800
require 'fzf'
require 'arraycsv'

p inf = Dir['*.mp4'].fzf.first

exit unless inf
sane_name = inf.gsub(/[^\w\d.]/, '_')

cuts_df = ArrayCSV.new("stack-#{sane_name}.csv")
cuts_df.empty? && cuts_df << %w[00:00:00.000 00:00:01.000]
cuts = cuts_df.map # shared

# 3840 x 2160 (or 2160p)
# 2560 x 1440 (or 1440p)
# 1920 x 1080 (or 1080p)
# 1280 x 720 (or 720p)
# 854 x 480 (or 480p)
# 720 x 480 (or 480p) 
# 640 x 360 (or 360p)
# 426 x 240 (or 240p)
# 320 x 240 (or 240p)

# scale=%w[320 426 640 720 854].fzf.first

scale=640 #unless scale

cmd=[]
cmd<<'ffmpeg'

cuts.take(4).each_with_index do |(ss, to), i|
  cmd << "-ss #{ss} -to #{to} -i '#{inf}'"
end

filter=[
  %([0:a][1:a][2:a][3:a]amix=inputs=4:duration=shortest[a]),
	%([0:v]scale=#{scale}:-1[v0]),
	%([1:v]scale=#{scale}:-1[v1]),
	%([2:v]scale=#{scale}:-1[v2]),
	%([3:v]scale=#{scale}:-1[v3]),
	%([v0][v1]hstack=inputs=2:shortest=1[top]),
  %([v2][v3]hstack=inputs=2:shortest=1[bot]),
  %([top][bot]vstack=inputs=2:shortest=1,scale=1280:720[v]),
 ].join(';')

cmd<<%(-filter_complex '#{filter}') 
cmd<<%(-map "[v]") 
cmd<<%(-map "[a]") 
cmd<<%(-ac 2) 
cmd<<"stacked_#{sane_name}"

p cmd

IO.popen(cmd.join(' '), &:read)
