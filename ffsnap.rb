#!/usr/bin/env ruby
# Id$ nonnax 2021-11-15 20:44:06 +0800
# ffmpeg -ss 0.5 -i inputfile.mp4 -vframes 1 -s 480x300 -f image2 imagefile.jpg

# The various options:
# 
    # -vframes 1: limit to 1 frame extracted
    # -ss 0.5: point of movie to extract from (ie seek to 0.5 seconds; you can also use HH:MM:SS.ZZZZ sexagesimal format)
    # -s 480x300: frame size of image to output (image resized to fit dimensions)
    # -f image2: forces format

require 'rubytools/file_ext'
inf, start = ARGV.size>1 ? ARGV : [nil]+ARGV
inf ||= ENV['fx'].split("\n").first
exit unless inf
sane_name = File.basename(inf).to_safename

p cmd="ffmpeg -ss #{start} -i '#{inf}' -vframes 1 -s 480x320 -f image2 isnap_#{sane_name}.jpg"
IO.popen(cmd, &:read)
