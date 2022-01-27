#!/usr/bin/env ruby
# Id$ nonnax 2021-10-28 02:44:56 +0800
# require 'fzf'

f=ARGV.first
begin
  cmd=<<~___
    ffmpeg 
    -hide_banner  # clean up
    -nostats      # clean up
    -i '#{f}' 
    -af volumedetect 
    -vn           # no detect video
    -sn 
    -dn 
    -f null 
    -y nul 2>&1
  ___

  cmd.gsub!(/\#.+$/,'')
  cmd.gsub!(/\n/, ' ')
  
  detected=IO.popen(cmd) do |io| 
    io
    .readlines(chomp:true)
    .grep(/max_volume/)
    .pop
    .split(/:/)
    .last
    .strip
    .gsub(/\s+/,'')
  end
rescue => e
  p [:error, e, f]
ensure
  puts [f, detected].join("\t")
end
# stackoverload sample
# ffmpeg -i sound.mp3 -af volumedetect -f null -y nul &> original.txt
# grep "max_volume" original.txt > original1.tmp
# sed -i 's|: -|=|' original1.tmp
# if [ $? = 0 ]
 # then
 # sed -i 's| |\r\n|' original.tmp
 # sed -i 's| |\r\n|' original.tmp
 # sed -i 's| |\r\n|' original.tmp
 # sed -i 's| |\r\n|' original.tmp
 # grep "max_volume" original1.tmp > original2.tmp
 # sed -i 's|max_volume=||' original2.tmp
 # yourscriptvar=$(cat "./original2.tmp")dB
 # rm result.mp3
 # ffmpeg -i sound.mp3 -af "volume=$yourscriptvar" result.mp3
 # ffmpeg -i result.mp3 -af volumedetect -f null -y nul &> result.txt
# fi
