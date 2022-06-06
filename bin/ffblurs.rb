#!/usr/bin/env ruby
# Id$ nonnax 2022-06-03 13:40:48 +0800

# luma_radius=50:chroma_radius=25:luma_power=1
require 'erb'

f,rad=ARGV

rad ||= 5

cmd=<<~___
ffmpeg -i '#{f}' -filter_complex 
  "[0:v]boxblur=luma_radius=#{rad}:chroma_radius=#{rad}:luma_power=1[blurred]" 
  -map "[blurred]" -map 0:a 'blur_#{f}'
___

def template
  cmd=DATA.read
  cmd.gsub!(/\n{1,}/,' ')
end


# p cmd = ERB.new(template).result(binding)
cmd.gsub!(/\n/,' ')

IO.popen(cmd, &:read)

__END__
ffmpeg -i '<%=f%>' 
-lavfi 
'[0:v]scale=ih*16/9:-1,boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[bg][0:v]overlay=(W-w)/2:(H-h)/2,crop=h=iw*9/16' 
-vb 800K 'blur_<%=f%>'

