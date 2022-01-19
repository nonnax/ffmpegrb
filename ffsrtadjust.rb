#!/usr/bin/env ruby
# Id$ nonnax 2022-01-17 09:13:05 +0800

require 'rubytools/time_and_date_ext'

ms_to_trim = ARGV.pop
ms_to_trim ||= 1000 
ms_to_trim = ms_to_trim.to_i 

ARGF.each_line do |l|
    acc=[]
    if l.match(':') 
        a,b = l.strip.gsub(',', '.')
               .split(/\s?-->\s?/) 
        acc= [a, b]
          .map(&:to_ms)
          .map{|e| e-ms_to_trim}
          .map(&:to_ts)
          .join(' --> ') rescue 'none'
        puts acc
    else
        puts l
    end
end
