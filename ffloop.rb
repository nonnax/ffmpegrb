#!/usr/bin/env ruby
# Id$ nonnax 2021-10-29 18:18:11 +0800
f=ENV['fx'].split("\n").first
inf=File.basename(f)
puts "how many loops"
loops = gets.chomp

cmd = ["ffmpeg"] 
cmd <<"-stream_loop #{loops} -i '#{inf}' -c copy"
# cmd <<'-c:v libx264'
cmd <<'-pix_fmt yuv420p'
cmd <<"'vloop_#{loops}x_#{inf}'"

IO.popen(cmd.join(' '), &:read)
