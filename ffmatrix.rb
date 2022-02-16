#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-10-16 20:23:17 +0800
# ffmatrix.rb <rows> <cols>
require 'rubytools/array_table'
require 'fflib'

def layout(row, col, res: '1080p')
  scale = SCALES[res.to_s]
  rule = lambda { |k, i|
    return 0 if i.zero?

    if i == 1
      "#{k}0"
    elsif i > 1
      "#{k}#{i - 2}+#{k}#{i - 1}"
    end
  }

  streams = (0..(row * col) - 1).to_a
  vstreams = []
  astreams = []

  avstreams = streams.inject([]) do |a, i|
    a << "[#{i}:v]setpts=PTS-STARTPTS,scale=640:-1[v#{i}]"
  end

  streams.size.times do |i|
    vstreams << "[v#{i}]"
    astreams << "[#{i}:a]"
  end

  data=row.times.map do |h|
          col.times.map do |w|
            [rule['w', w], rule['h', h]].join('_')
          end
        end

  # yield data if block_given?

  builder = []
  builder << avstreams.join(";\n")
  builder << ';'
  builder << "\n"
  builder << vstreams.join
  builder << "xstack=inputs=#{streams.size}:shortest=1:layout="
  builder << data.join('|')
  builder << ','
  builder << "scale=#{scale}"
  builder << '[v]'
  builder << ';'
  builder << "\n"
  builder << astreams.join
  builder << "amix=inputs=#{astreams.size}:duration=shortest[a]"
  builder.join
end

row, col, res = ARGV.map(&:to_i)
# puts layout(row, col){|b| puts b.to_table}
puts layout(row, col, res: res)

# filter=<<~FFMPEG
# [0:v]setpts=PTS-STARTPTS,scale=640:-1[v0]
# [1:v]setpts=PTS-STARTPTS,scale=640:-1[v1]
# [2:v]setpts=PTS-STARTPTS,scale=640:-1[v2]
# [3:v]setpts=PTS-STARTPTS,scale=640:-1[v3]
# [v0][v1][v2][v3]xstack=inputs=4:shortest=1:layout=0_0|w0_0|0_h0|w0_h0,scale=1280:720[v]
# [0:a][1:a][2:a][3:a]amix=inputs=4:duration=shortest[a]
# FFMPEG

# [0:v] setpts=PTS-STARTPTS, scale=qvga [a0]; \
# [1:v] setpts=PTS-STARTPTS, scale=qvga [a1]; \
# [2:v] setpts=PTS-STARTPTS, scale=qvga [a2]; \
# [3:v] setpts=PTS-STARTPTS, scale=qvga [a3]; \
# [4:v] setpts=PTS-STARTPTS, scale=qvga [a4]; \
# [5:v] setpts=PTS-STARTPTS, scale=qvga [a5]; \
# [6:v] setpts=PTS-STARTPTS, scale=qvga [a6]; \
# [7:v] setpts=PTS-STARTPTS, scale=qvga [a7]; \
# [8:v] setpts=PTS-STARTPTS, scale=qvga [a8]; \
# [a0][a1][a2][a3][a4][a5][a6][a7][a8]xstack=inputs=9:layout=0_0|w0_0|w0+w1_0|0_h0|w0_h0|w0+w1_h0|0_h0+h1|w0_h0+h1|w0+w1_h0+h1[out] \
