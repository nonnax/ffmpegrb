#!/usr/bin/env ruby
infile, srt=ARGV
exit unless infile
cmd="ffmpeg -i #{infile} -vf subtitles=#{srt} subbed_#{infile}"
IO.popen(cmd, &:read)
