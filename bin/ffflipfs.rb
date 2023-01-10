#!/usr/bin/env ruby
# Id$ nonnax 2021-10-26 23:51:26 +0800
# "ffmpeg -i INPUT -vf vflip -c:a copy OUTPUT"

def flip(inf, flip:'hflip')
  cmd=<<~FFMPEG
    ffmpeg
    -i '#{inf}'
    -vf #{flip}
    -pix_fmt yuv420p
    -crf 20
    -c:a copy
    'v#{flip}_#{inf}'
  FFMPEG
  cmd.gsub!(/\n/, ' ')
  IO.popen(cmd, &:read)
end

ENV['fs'].split(/\n/).each do |e|
    fname=File.basename(e)
    flip(fname)
end
