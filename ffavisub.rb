#!/usr/bin/env ruby
# Id$ nonnax 2022-01-17 09:13:05 +0800
# burns ass subtitles into new video output
# default scale: 640:480
# ffavisub.rb <vid.mp4> <scale> 

# ffmpeg -i input.mkv -sn -c:a libmp3lame -ar 48000 -ab 128k -ac 2 -c:v libxvid \
# -crf 24 -vtag DIVX -vf scale=640:480 -aspect 4:3 -mbd rd -flags +mv4+aic \
# -trellis 2 -cmp 2 -subcmp 2 -g 30 -vb 1500k output.avi

# require 'fflib'
infile, scale = ARGV
scale ||= '480'

# size=SCALES[scale]
size='640:480'

inf=File.basename(infile, '.*')
# preprocess sub
# convert srt into ass
cmd="ffmpeg -i #{inf}.srt #{inf}.ass"
IO.popen(cmd, &:read)

# burn ass subtitles into new video output
cmd=<<~CMD
  ffmpeg -i #{infile} 
  -filter_complex '[0:v:0] scale=#{size}, subtitles=#{inf}.ass [v]'
  -map '[v]'
  -map 0:a
  -c:a libmp3lame -ar 48000 -ab 128k -ac 2
  -c:v libxvid
  -vtag DIVX 
  -q:a 5
  -q:v 5
  -crf 23
  sub-#{infile}.avi
CMD
cmd.gsub!(/\n/, ' ')

IO.popen(cmd, &:read)

# cmd="ffmpeg -i #{infile} -f srt -i #{srt} -c:v copy -c:a copy -c:s mov_text sub-#{infile}"
# cmd="ffmpeg -i #{infile} -vf ass=#{srt}.ass -max_interleave_delta sub-#{infile}" # mkv
