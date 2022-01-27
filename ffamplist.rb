#!/usr/bin/env ruby
# Id$ nonnax 2022-01-26 12:52:22 +0800
# ffaudioboostarg.rb <listfile> <vol>
f=ARGV.first
File.readlines(f, chomp: true).each do |l|
    f, vol = l.split(/\t/)
    IO.popen(['ffaudioboostarg.rb', f, vol], &:read)
end    
