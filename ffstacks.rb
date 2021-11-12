#!/usr/bin/env ruby
# Id$ nonnax 2021-10-13 20:38:45 +0800
require 'fzf'
require 'arraycsv'
require 'file_ext'

p inf = Dir['*.mp4'].fzf.first

exit unless inf
sane_name = inf.to_safename

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
size=[2, 3, 4, 6, 8].fzf.first.to_i rescue 4
# size=4 unless size
scale=640 #unless scale

cmd=[]
cmd<<'ffmpeg'

cuts.take(size*size).each_with_index do |(ss, to), i|
  cmd << "-ss #{ss} -to #{to} -i '#{inf}'"
end

filter=IO.popen("ffmatrix.rb #{size} #{size}", &:read)

# filter=<<~FFMPEG
	# [0:v]setpts=PTS-STARTPTS,scale=640:-1[v0]
	# [1:v]setpts=PTS-STARTPTS,scale=640:-1[v1]
	# [2:v]setpts=PTS-STARTPTS,scale=640:-1[v2]
	# [3:v]setpts=PTS-STARTPTS,scale=640:-1[v3]
	# [v0][v1][v2][v3]xstack=inputs=4:shortest=1:layout=0_0|w0_0|0_h0|w0_h0,scale=1280:720[v]
	# [0:a][1:a][2:a][3:a]amix=inputs=4:duration=shortest[a]
# FFMPEG

filter.gsub!(/\n/,'')
filter.gsub!(/;$/, '')

cmd<< %(-filter_complex '#{filter.chomp}') 
cmd<< %(-map "[v]") 
cmd<< %(-map "[a]") 
cmd<< '-ac 2'
# cmd<< '-shortest'
cmd<< "vstacked_#{size}_#{sane_name}"

puts cmd

IO.popen(cmd.join(' '), &:read)
