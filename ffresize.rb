#!/usr/bin/env ruby
# Id$ nonnax 2021-10-14 00:53:32 +0800
require 'optparse'
require 'rubytools/fzf'

inf, _ = ARGV
opts={}
OptionParser.new do |o|
  o.banner=('sizes: 240 360 480 720 1080')
  o.on('-sSIZE', '--size=SIZE')
  o.on('-pPRESET', '--preset=PRESET')
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


begin
          
  sizes=s.zip(res).to_h

  size=sizes.fetch(s.fzf.first || '480')
  # size=sizes[opts.fetch(:size, '480')]
  # preset=opts.fetch(:preset, 'fast')
  # -crf 27
  size_h = size.split(':').last
  preset=%w[ultrafast superfast veryfast faster fast medium slow slower veryslow placebo].fzf.first
  outf = "#{size_h}-#{inf}"
  cmd=<<~___
    ffmpeg 
    -hide_banner    
    -i '#{inf}'    
    -c:v libx265
    -preset #{preset}
    -c:a copy
    -filter:v scale=-1:#{size_h}
    '#{outf}.mp4'
  ___

  cmd.gsub!(/\n+/, ' ')
  IO.popen(cmd, &:read)

rescue=>e
  p e

ensure

  puts <<~___
  Last command: 
  #{cmd}
  Use the slowest preset you have patience for.

  To get a "visually lossless" quality, you can use:
  ffmpeg -i MyMovie.mkv -vf scale=-1:720 -c:v libx265 -crf 18 -preset veryslow -c:a copy MyMovie_720p.mkv
  ___

end
