#!/usr/bin/env ruby
# Id$ nonnax 2022-01-17 09:13:05 +0800
infile, size = ARGV
size ||= '480'

res=['320:240', 
     '640:360', 
     '854:480', 
     '1280:720', 
     '1920:1080']

s=res.map do |e| 
    e
    .split(':')
    .last 
end

p sizes=s.zip(res).to_h
size=sizes[size]
# ffmpeg -i input.mkv -filter_complex "[0:v:0]scale=1280:720,subtitles=individual.ass[v]" -map "[v]" -map 0:a -map 0:s -c copy -c:v libx265 -crf 32 output.mkv

# cmd="ffmpeg -i #{infile} -f srt -i #{srt} -c:v copy -c:a copy -c:s mov_text sub-#{infile}"
inf=File.basename(infile, '.*')
p cmd="ffmpeg -i #{inf}.srt #{inf}.ass"
IO.popen(cmd, &:read)

# cmd="ffmpeg -i #{infile} -vf ass=#{srt}.ass -max_interleave_delta sub-#{infile}" # mkv
cmd=<<~CMD
  ffmpeg -i #{infile} 
  -filter_complex '[0:v:0]scale=#{size},subtitles=#{inf}.ass[v]'
  -map '[v]'
  -map 0:a
  -c copy 
  -c:v libx265
  -crf 32
  sub-#{infile}
CMD
cmd.gsub!(/\n/, ' ')

IO.popen(cmd, &:read)
