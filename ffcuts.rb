#!/usr/bin/env ruby
# frozen_string_literal: true

# cuts.rb
#   an ffmpeg tool to cut sections from a single input
# -*- nonnax  -*- : 2021-09-30 01:37:01 +0800
require 'fzf'
require 'arraycsv'
require 'file_ext'

p inf = Dir['*.*'].fzf.first

exit unless inf
name, _ = File.splitname(inf.to_safename)


cuts_df = ArrayCSV.new("cut-#{name}.csv")
cuts_df.empty? && cuts_df << %w[00:00:00.000 00:00:01.000]
cuts = cuts_df.map # shared

cuts.each_with_index do |(ss, to), i|
  cmd = []
  cmd << 'ffmpeg'  
  cmd << "-i '#{inf}' -ss #{ss} -to #{to}"
  cmd << '-c copy'
  # cmd << '-async 1'
  # cmd << '-pix_fmt yuv420p'
  cmd<< "'vseg_%s_%s.mp4'" % [ss.tr(':', '_'), name]
  p cmd_str = cmd * ' '
  IO.popen(cmd_str, &:read)
  sleep 1
end

