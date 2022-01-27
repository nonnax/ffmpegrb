#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-10-13 20:38:45 +0800
# ffstacks.rb <file><row><col>
# update the stack-<file>

require 'rubytools/fzf'
require 'rubytools/array_csv'
require 'rubytools/file_ext'

inf, row, col = ARGV

msg = <<~___
  ffstacks.rb <file><row><col> and update the stack-<file>
___

raise msg unless [inf, row, col].all?

sane_name = inf.to_safename

cuts_df = ArrayCSV.new("stack-#{sane_name}.csv")
cuts_df.empty? && cuts_df << %w[00:00:00.000 00:00:01.000]
cuts = cuts_df.map # shared

row &&= row.to_i
col &&= col.to_i
size = row * col

cmd = []
input_files = []

cuts.take(size).each do |ss, to|
  input_files << "-ss #{ss} -to #{to} -i '#{inf}'"
end

filter = IO.popen("ffmatrix.rb #{row} #{col}", &:read)

# filter=<<~FFMPEG
# [0:v]setpts=PTS-STARTPTS,scale=640:-1[v0]
# [1:v]setpts=PTS-STARTPTS,scale=640:-1[v1]
# [2:v]setpts=PTS-STARTPTS,scale=640:-1[v2]
# [3:v]setpts=PTS-STARTPTS,scale=640:-1[v3]
# [v0][v1][v2][v3]xstack=inputs=4:shortest=1:layout=0_0|w0_0|0_h0|w0_h0,scale=1280:720[v]
# [0:a][1:a][2:a][3:a]amix=inputs=4:duration=shortest[a]
# FFMPEG

filter.gsub!(/\n/, '')
filter.gsub!(/;$/, '')

cmd=<<~___
  ffmpeg
  #{input_files.join(' ')}
  -filter_complex '#{filter.chomp}'
  -map '[v]'
  -map '[a]'
  -ac 2
  vstacked_#{row}x#{col}_#{sane_name}
___
cmd.gsub!(/\n/, ' ')
puts cmd

IO.popen(cmd, &:read)

# 3840 x 2160 (or 2160p)
# 2560 x 1440 (or 1440p)
# 1920 x 1080 (or 1080p)
# 1280 x 720 (or 720p)
# 854 x 480 (or 480p)
# 720 x 480 (or 480p)
# 640 x 360 (or 360p)
# 426 x 240 (or 240p)
# 320 x 240 (or 240p)
