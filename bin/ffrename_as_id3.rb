#!/usr/bin/env ruby
# Id$ nonnax 2022-02-10 14:49:33 +0800
require 'json'
require 'rubytools/file_ext'

f, _ = ARGV

cmd=<<~___
  ffprobe
  -hide_banner 
  -show_format 
  -print_format json
  #{f}
  2>1
___

cmd.gsub!(/\n/, ' ')

json=IO.popen(cmd, &:read)

h=JSON.parse(json)
f = h.dig('format', 'filename')
new_f = h
  .dig('format', 'tags')
  .values_at('artist', 'title', 'album')
  .map{ |e| e.to_safename if e.respond_to?(:to_safename) }
  .join('-')+'.mp3'
  
puts [f, new_f].join("\t")
