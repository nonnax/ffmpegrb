#!/usr/bin/env ruby
infile, srt = ARGV
# cmd="ffmpeg -i #{infile} -f srt -i #{srt} -c:v copy -c:a copy -c:s mov_text sub-#{infile}"
cmd="ffmpeg -i #{infile} -f srt -i #{srt} -c:v copy -c:a copy -c:s mov_text sub-#{infile}"
IO.popen(cmd, &:read)
