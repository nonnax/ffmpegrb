#!/usr/bin/env ruby
infile = ARGV.first
# cmd="ffmpeg -i #{infile} -f srt -i #{srt} -c:v copy -c:a copy -c:s mov_text sub-#{infile}"
inf=File.basename(infile, '.*')
cmd="ffmpeg -i #{inf}.srt #{inf}.ass"
IO.popen(cmd, &:read)

# cmd="ffmpeg -i #{infile} -vf ass=#{srt}.ass -max_interleave_delta sub-#{infile}"
cmd="ffmpeg -i #{infile} -vf ass=#{inf}.ass sub-#{infile}"
IO.popen(cmd, &:read)
