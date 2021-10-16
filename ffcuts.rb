#!/usr/bin/env ruby
# frozen_string_literal: true

# cuts.rb
#   an ffmpeg tool to cut sections from a single input
# -*- nonnax  -*- : 2021-09-30 01:37:01 +0800
require 'fzf'
require 'arraycsv'

p inf = Dir['*.*'].fzf.first

exit unless inf
sane_name = inf.gsub(/[^\w\d.]/, '_')

cuts_df = ArrayCSV.new("cut-#{sane_name}.csv")
cuts_df.empty? && cuts_df << %w[00:00:00.000 00:00:01.000]
cuts = cuts_df.map # shared

cuts.each_with_index do |(ss, to), i|
	cmd = []
	cmd << 'ffmpeg'
  cmd << "-ss #{ss} -to #{to} -i '#{inf}'"
	cmd << '-c copy'
	# cmd << '-c:v libx264 -crf 18 -preset veryslow'
	# cmd<< '-vf mp=eq2=1:1.68:0.3:1.25:1:0.96:1'
	cmd << '-avoid_negative_ts make_zero'
	cmd << "'seg_%s_%s'" % [ss.tr(':', '_'), sane_name]
	p cmd_str = cmd * ' '
	IO.popen(cmd_str, &:read)
end

