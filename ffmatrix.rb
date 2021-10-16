#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-10-16 20:23:17 +0800
require 'array_table'

def layout(row, col)
  rule = lambda { |k, i|
    return 0 if i.zero?

    if i == 1
      "#{k}0"
    elsif i > 1
      "#{k}#{i - 2}+#{k}#{i - 1}"
    end
  }
  data = []
  row.times do |h|
    builder = []
    col.times do |w|
      builder << [rule['w', w], rule['h', h]].join('_')
    end
    data << builder
  end
  data
end

row, col = ARGV

layout(row.to_i, col.to_i)
  .tap { |r| puts r.flatten.join('|') }
# .tap{|r| puts r.to_table; puts }
