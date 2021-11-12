#!/usr/bin/env ruby
# frozen_string_literal: true

# cuts.rb
#   an ffmpeg tool to cut sections from a single input
# -*- nonnax  -*- : 2021-09-30 01:37:01 +0800
require 'fzf'
require 'arraycsv'
require 'file_ext'

p inf = Dir['*.*'].fzf.first
# size=['1280:720', '1920:1080'].fzf(cmd: %(fzf --prompt='dimension')).first

exit unless inf
sane_name, _ = File.splitname(inf.to_safename)

cuts_df = ArrayCSV.new("cut-#{sane_name}.csv")
cuts_df.empty? && cuts_df << %w[00:00:00.000 00:00:01.000]
cuts = cuts_df.map # shared

cuts.each_with_index do |(ss, to), i|
  cmd = []
  cmd << 'ffmpeg'
  cmd << "-i '#{inf}' -ss #{ss} -to #{to}"
  cmd << '-c:a copy'
  cmd << '-c:v libx264'
  cmd << '-crf 20 -preset slow'
  cmd << '-pix_fmt yuv420p'
  cmd << '-movflags +faststart'
  cmd<< "'vseg_%s_%s.mp4'" % [ss.tr(':', '_'), sane_name]
  p cmd_str = cmd * ' '
  IO.popen(cmd_str, &:read)
end

