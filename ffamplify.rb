#!/usr/bin/env ruby
# Id$ nonnax 2021-10-11 22:47:15 +0800
# Used with lf file manager file selections
require 'fzf'

text=[]

volume=(-5..5).map{|i| 
	"%ddB" % [i*5]
}.fzf.first

ENV["fs"].split("\n").each  do |f|
	basename=f.split(%r(/)).last
	# p cmd="ffmpeg -i '#{f}' -vcodec copy -af 'volume=#{volume}'  '#{volume}-#{basename}'"
	p cmd="ffmpeg -i '#{f}' -filter:a 'volume=#{volume}'  'amp-#{basename}'"
	IO.popen(cmd, &:read)
end
