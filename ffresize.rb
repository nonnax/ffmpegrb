#!/usr/bin/env ruby
# Id$ nonnax 2021-10-14 00:53:32 +0800
require 'optparse'
#To get a "visually lossless" quality, you can use:
#ffmpeg -i MyMovie.mkv -vf scale=-1:720 -c:v libx264 -crf 18 -preset veryslow -c:a copy MyMovie_720p.mkv
# inf=Dir["*.m*"].fzf.first
# size=['1280:720', '1920:1080'].fzf(cmd: %(fzf --prompt='dimension')).first
# exit unless inf

opts={}
OptionParser.new do |o|
  o.banner=('sizes: 240 360 480 720 1080')
  o.on('-sSIZE', '--size=SIZE')
end.parse!(into: opts)

# s=%w[240 360 480 720 1080]
res=['320:240', 
     '640:360', 
     '854:480', 
     '1280:720', 
     '1920:1080']
s=res.map do |e| e
              .split(':')
              .last 
          end
p sizes=s.zip(res).to_h
size=sizes[opts.fetch('size', '480')]

cmd=<<~___
  ffmpeg -i '#{inf}'
  -filter:v fps=25,scale=#{size}
  -c:v libx264
  -crf 21 -preset veryslow
  -c:a copy
  -pix_fmt yuv420p
  -movflags +faststart
  '#{size.split(':').last}-#{inf}'
___
p cmd.gsub!(/\n+/, ' ')
IO.popen(cmd, &:read)
