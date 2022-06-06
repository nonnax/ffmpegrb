#!/usr/bin/env ruby
# Id$ nonnax 2022-02-20 21:49:32 +0800
tag=<<~___
<font color="#3399CC">burnsubs by @nonnax (twitter)</font>
___

            #/\d{2}:\d{2}:\d{2},\d{3} --> \d{2}:\d{2}:\d{2},\d{3}/
# RE_TIMESTAMP=/(\d{2}):\1:\1,(\d{3}) --> \1:\1:\1,\2/

# l='00:00:00,100 --> 00:00:00,100'
RE_TIMESTAMP=/
    # (00):00:00,(100) captures \1 \2
    ( [[:digit:]]{2} )  :\1 :\1 , ( [[:digit:]]{3} )
    [[:space:]]+
    --> # an arrow surrounded by spaces
    [[:space:]]+
    # backreferences pattern above
    # 00:00:00,100
    \1:\1:\1,\2
/x

prev=''
ARGF.each_line do |l|
  puts l
  if prev.match?(/^1\s+$/) && l.match?(RE_TIMESTAMP)
    puts tag
  end
  prev=l.dup
end
puts tag
