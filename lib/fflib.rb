#!/usr/bin/env ruby
# Id$ nonnax 2022-01-21 14:54:29 +0800
res=['320:240', 
     '640:360', 
     '854:480', 
     '1280:720', 
     '1920:1080']

s=res.map do |e| 
    e
    .split(':')
    .last 
end

SCALES=s.zip(res).to_h
