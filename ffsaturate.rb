#!/usr/bin/env ruby
# Id$ nonnax 2021-10-19 22:05:06 +0800
#
# $ ffmpeg -i input.mp4 -filter_complex "vibrance=intensity=-2:gbal=10" -pix_fmt yuv420p output.mp4
# intensity, strength of the saturation boost. (2 to -2 default 0)
# rbal, red balance (10 to -10 default 1)
# gbal, green balance (10 to -10 default 1)
# bbal, blue balance (10 to -10 default 1)
# rlum, red luma coefficient (1 to 0 default 0)
# glum, green luma coefficient (1 to 0 default 0)
# blum, blue luma coefficient (1 to 0 default 0)

def saturate(inf, intensity:1.05)
  cmd=<<~FFMPEG
    ffmpeg 
    -i '#{inf}'
    -filter_complex "vibrance=intensity=#{intensity}" 
    -crf 20
    -pix_fmt yuv420p 
    -c:a copy
    'vvib_#{inf}'
  FFMPEG
  cmd.gsub!(/\n/, ' ')
  IO.popen(cmd, &:read)
end

ENV['fs'].split(/\n/).each do |e|
  basename=File.basename(e)
  saturate(basename)
end
