#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-10-14 00:53:32 +0800
require 'optparse'
require 'rubytools/fzf'

RES =
  %w[
    320:240
    640:360
    854:480
    1280:720
    1920:1080
  ].freeze

PRESET =
  %w[
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
  ].freeze

BANNER = <<~___
    #{File.basename __FILE__} <file> --size=<360> --preset=<medium>
    sizes are: #{RES.map{|e| e.split(':').last }.join(' | ')}
    presets are: #{PRESET.join(' | ')}
___


inf, = ARGV

opts = {}
OptionParser.new do |o|
  o.banner = BANNER
  o.on('-sSIZE', '--size=SIZE')
  o.on('-pPRESET', '--preset=PRESET')
end.parse!(into: opts)

size_re = Regexp.new opts.fetch(:size, '360')
preset_re = Regexp.new opts.fetch(:preset, 'medium')

if opts.empty?
  puts BANNER
  exit
end

begin
  # -crf 27
  res =
    RES
    .grep(size_re)
    .first

  preset =
    PRESET
    .grep(preset_re)
    .first

  size_h = res.split(':').last

  cmd = <<~___
    ffmpeg
    -hide_banner
    -i '#{inf}'
    -c:v libx265
    -preset #{preset}
    -crf 25
    -c:a copy
    -filter:v scale=#{res}
    '#{size_h}p-#{inf}-hevc.mp4'
  ___
  cmd.gsub!(/\n+/, ' ')

  IO.popen(cmd, &:read)
rescue StandardError => e
  p e
ensure
  puts BANNER

  puts <<~___
    Last command:#{' '}
    #{cmd}

    Use the slowest preset you have patience for.

    To get a "visually lossless" quality, you can use:
    ffmpeg -i MyMovie.mkv -vf scale=-1:720 -c:v libx265 -crf 18 -preset veryslow -c:a copy MyMovie_720p.mkv
  ___
end
