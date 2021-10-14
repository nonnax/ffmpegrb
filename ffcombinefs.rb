#!/usr/bin/env ruby
# Id$ nonnax 2021-10-10 22:56:31 +0800
# Used with lf file manager file selections
#	select pairs of axx.mp3 vxx.mp4 sequentially numbered files to merge

def combine(v, a)
	cmd=[]
	cmd<<"ffmpeg"
	cmd<<"-i '#{v}'"
	cmd<<"-i '#{a}'"
	cmd<<"-c copy -map 0:0 -map 1:0"
	cmd<<"-shortest"
	cmd<<"#{v}#{a}.mp4"

	IO.popen(cmd.join(' '), &:read)
end

a=[]

ENV['fs'].split("\n").map{|e|
	basename=e.split(%r(/)).last
	a<<basename 
}

part = a.sort.partition{|e| e.match(/^v/)}

part.transpose.each{|v, a|
	combine(v, a)
}

