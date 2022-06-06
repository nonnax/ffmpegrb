#!/usr/bin/env ruby
# Id$ nonnax 2022-01-17 09:13:05 +0800
# ffaddass.rb <file><size>

infile, size = ARGV

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

puts <<~___
ffaddass.rb <file><size>
#{(['sizes are:']+s).join(' ')}
___
exit unless [infile, size].all?

size ||= '480'
sizes=s.zip(res).to_h
size=sizes[size]

inf=File.basename(infile, '.*')
p cmd="ffmpeg -i #{inf}.srt #{inf}.ass"
IO.popen(cmd, &:read)

cmd=(
<<~CMD
  ffmpeg -i #{infile} 
  -filter_complex '[0:v:0]scale=#{size},subtitles=#{inf}.ass[v]'
  -map '[v]'
  -map 0:a
  -c copy 
  -c:v libx265
  -crf 25
  hevc-#{infile}
CMD
).gsub(/\n/, ' ')

IO.popen(cmd, &:read)
