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
	cmd=<<~FFMPEG
		ffmpeg 
		-i '#{f}' 
		-filter:a 'volume=#{volume}'  
		'a_#{volume}_#{basename}'
	FFMPEG
	cmd.gsub!(/\n/,' ')
	IO.popen(cmd, &:read)
end
