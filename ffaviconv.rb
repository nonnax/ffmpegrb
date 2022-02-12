#!/usr/bin/env ruby
# Id$ nonnax 2022-01-25 10:04:44 +0800


# FFmpeg wiki has a page about this: MPEG-4 Encoding Guide.

# Long story short: ffmpeg -i input.avi -c:v mpeg4 -vtag xvid output.avi
# 
# There are, of course, different support levels on different devices. 
#  The email exchange about a very limited device Need code to convert MP4 to DivX AVI 
#  seems to point at a lower level standard (use it if you can't test the device beforehand):
# 
# ffmpeg -i input.mkv -sn -c:a libmp3lame -ar 48000 -ab 128k -ac 2 -c:v libxvid \
    # -crf 24 -vtag DIVX -vf scale=640:480 -aspect 4:3 -mbd rd -flags +mv4+aic \
    # -trellis 2 -cmp 2 -subcmp 2 -g 30 -vb 1500k output.avi
require 'fflib'
require 'rubytools/fzf'

infile, scale=ARGV

fail "missing input video" unless infile

inf=File.basename(infile, '.*')
p size=RESOLUTIONS.select{|r| r.match(/#{scale}/) }.first || '640:480'
scale_name='640:480'.split(':').last

cmd=<<~CMD
  ffmpeg 
  -hide_banner    
  -i #{infile} 
  -filter_complex '[0:v:0]scale=#{size}[v]'
  -map '[v]'
  -map 0:a
  -c:v mpeg4
  -c:a libmp3lame 
  -ar 48000 
  -ab 128k 
  -ac 2
  -vtag DIVX 
  -preset medium
  -q:v 5
  -crf 22
  #{scale_name}-#{infile}.avi
CMD
cmd.gsub!(/\n+/, ' ' )

IO.popen(cmd, &:read)
