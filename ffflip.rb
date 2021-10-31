#!/usr/bin/env ruby
# Id$ nonnax 2021-10-26 23:51:26 +0800
# "ffmpeg -i INPUT -vf vflip -c:a copy OUTPUT"

def template
  "\"%s\"" % [DATA.read]
end

def flip(inf, flip:'hflip')
  cmd=eval(template, binding).gsub(/\n|\s{1,}/, ' ')
  IO.popen(cmd, &:read)
end

ENV['fs'].split(/\n/).each do |e|
  fname=File.basename(e)
  p flip(fname)
end

__END__
ffmpeg 
  -i '#{inf}'
  -vf #{flip}
  -pix_fmt yuv420p 
  -crf 20 
  -c:a copy
  'v#{flip}_#{inf}'
