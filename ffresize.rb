#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-10-14 00:53:32 +0800
require 'optparse'
require 'rubytools/fzf'

inf, = ARGV
opts = {}
OptionParser.new do |o|
  o.banner = ('sizes: 240 360 480 720 1080')
  o.on('-sSIZE', '--size=SIZE')
  o.on('-pPRESET', '--preset=PRESET')
end.parse!(into: opts)


begin
  # -crf 27
  res =
  %w[
    320:240
    640:360
    854:480
    1280:720
    1920:1080
  ].fzf.first

  preset = %w[
    ultrafast
    superfast
    veryfast
    faster
    fast
    medium
    slow
    slower
    veryslow
    placebo
  ].fzf.first

  size_h = res.split(':').last

  cmd = <<~___
    ffmpeg#{' '}
    -hide_banner#{'    '}
    -i '#{inf}'#{'    '}
    -c:v libx265
    -preset #{preset}
    -c:a copy
    -filter:v scale=#{res}
    '#{size_h}-#{inf}.mp4'
  ___
  cmd.gsub!(/\n+/, ' ')
  
  IO.popen(cmd, &:read)
rescue StandardError => e
  p e
ensure
  puts <<~___
    Last command:#{' '}
    #{cmd}
    Use the slowest preset you have patience for.

    To get a "visually lossless" quality, you can use:
    ffmpeg -i MyMovie.mkv -vf scale=-1:720 -c:v libx265 -crf 18 -preset veryslow -c:a copy MyMovie_720p.mkv
  ___
end
