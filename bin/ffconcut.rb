#!/usr/bin/env ruby
# frozen_string_literal: true

# concut.rb
#   an ffmpeg tool to cut and merge sections from a single input
# -*- nonnax  -*- : 2021-09-30 01:37:01 +0800
require 'rubytools'
require 'fzf'
require 'array_csv'
require 'file/file_ext' # String#to_safename


inf, = ARGV
inf = Dir['*.*'].fzf.first unless inf

exit unless inf

cuts_df = ArrayCSV.new("cut-#{inf.to_safename}.csv")
cuts_df.empty? && cuts_df << %w[00:00:00.000 00:00:01.000]
cuts = cuts_df.map # shared

cmd = []
istreams = []

cmd << 'ffmpeg'

cuts.each_with_index do |(ss, to), i|
  cmd << "-ss #{ss} -to #{to} -i '#{inf}'"
  istreams << format('[%d:v][%d:a]', i, i)
end
streams_enum = istreams.join(' ')

cmd << "-filter_complex '#{streams_enum}concat=n=#{cuts.size}:v=1:a=1[out]'"
cmd << "-map '[out]'"
cmd << "'vseg_#{inf.to_safename}'"
p cmd_str = cmd * ' '
IO.popen(cmd_str, &:read)
