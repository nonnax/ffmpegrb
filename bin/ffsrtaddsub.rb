#!/usr/bin/env ruby
# Id$ nonnax 2022-01-17 09:13:05 +0800

infile, srt = ARGV
# cmd="ffmpeg -i #{infile} -f srt -i #{srt} -c:v copy -c:a copy -c:s mov_text sub-#{infile}"
cmd="ffmpeg -i #{infile} -f srt -i #{srt} -c:v copy -c:a copy -c:s mov_text sub-#{infile}"
IO.popen(cmd, &:read)
