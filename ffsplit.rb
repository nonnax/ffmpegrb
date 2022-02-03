#!/usr/bin/env ruby
# frozen_string_literal: true

# cuts.rb
#   an ffmpeg tool to cut sections from a single input
# -*- nonnax  -*- : 2021-09-30 01:37:01 +0800
require 'rubytools/fzf'
require 'rubytools/array_csv'
require 'rubytools/file_ext'
require 'rubytools/time_and_date_ext'

inf, slice = ARGV

exit unless inf
name, ext = File.splitname(inf.to_safename)

total_time=IO.popen("ffprobetime.rb #{inf}", &:read)
cuts=total_time.timeslice(slice.to_i)

cuts_df = ArrayCSV.new("cut-#{name}.csv")
cuts_df.empty? && cuts_df << %w[00:00:00.000 00:00:01.000]
cuts_df.dataframe.replace cuts
cuts = cuts_df.map # shared

cuts.each_with_index do |(ss, to), i|
  # new_name=format "vseg_%{ss}_%{name}%{ext}", {ss: ss.tr(':', '_'), name:, ext:}
  new_name=format "%{i}-of-%{slice}-%{name}%{ext}", {slice: , i: i.succ, name:, ext:}

  cmd =<<~___
  ffmpeg
  -i '#{inf}' -ss #{ss} -to #{to}
  -c copy
  #{new_name}
  ___

  p cmd.gsub!(/\n+/, ' ')
  IO.popen(cmd, &:read)
end

