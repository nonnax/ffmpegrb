#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-10-06 19:52:32 +0800
# ffmpeg -i clip.mp4 -itsoffset 0.150 -i clip.mp4 -vcodec copy -acodec copy -map 0:0 -map 1:1 output.mp4
require 'fzf'
require 'file_ext'

puts 'how much delay (ms)?'
# delay = ARGV.first.to_i
delay = gets.chomp
inf = ENV['fs'].split("\n").first
outf = File.basename(inf).to_safename
cmd=<<~FFMPEG
	ffmpeg
	-i '#{inf}'
	-itsoffset #{delay}
	-i '#{inf}'
	-codec copy
	-map 0:0 -map 1:1
	out-#{outf}
FFMPEG

p cmd.gsub!(/\n/, ' ')
IO.popen(cmd, &:read)
