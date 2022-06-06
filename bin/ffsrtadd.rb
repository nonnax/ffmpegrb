#!/usr/bin/env ruby
# Id$ nonnax 2022-01-17 09:13:05 +0800

infile=ARGV.pop
infile_base=File.basename(infile, '.*')
exit unless infile
cmd="ffmpeg -i #{infile} -i #{infile_base}.srt -c copy -c:s mov_text srt_#{infile}"
IO.popen(cmd, &:read)
