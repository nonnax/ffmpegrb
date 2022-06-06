#!/usr/bin/env ruby
# Id$ nonnax 2022-01-26 22:26:42 +0800
require 'json'
require 'rubytools/ansi_color'
require 'rubytools/file_ext'

s=[]
ARGF.inject(s) do |acc,  l|
  acc<<l 
end
h=JSON.parse(s.join)
f     = h.dig('format', 'filename')
new_f = h
  .dig('format', 'tags')
  .values_at('artist', 'title', 'album')
  .map{ |e| e.to_safename if e.respond_to?(:to_safename) }
  .join('-')+'.mp3'
  
puts [f, new_f].join("\t")
