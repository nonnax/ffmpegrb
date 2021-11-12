#!/usr/bin/env ruby
# Id$ nonnax 2021-10-28 02:44:56 +0800
require 'fzf'
# -hide_banner 
Dir["*.m*", "*.o*"].fzf_preview('ffmpeg -hide_banner -nostats -i {} -af "volumedetect" -vn -sn -dn -f null /dev/null')

