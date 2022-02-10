#!/usr/bin/env ruby
# Id$ nonnax 2021-10-29 18:18:11 +0800
f, loops=ARGV
inf=File.basename(f)

fail 'ffloop <loops>' unless [f, loops].all?

cmd = ["ffmpeg"] 
cmd <<"-stream_loop #{loops} -i '#{inf}' -c copy"
# cmd <<'-c:v libx265'
# cmd <<'-c:a copy'
cmd <<'-c copy'
cmd <<'-pix_fmt yuv420p'
cmd <<"'vloop_#{loops}x_#{inf}'"

IO.popen(cmd.join(' '), &:read)
