#!/usr/bin/env ruby
# Id$ nonnax 2023-03-23 11:54:59 +0800
require 'texticle/texticle'
require 'file/file_importer'
require 'time/time_ext'

class FFMpeg
  attr :cmd
  def initialize(f, **params)
    @template = FileImporter.parse(File.read(f))
    @params = params
  end

  def render
    p @cmd=Texticle.parse(@template, **@params).gsub(/\n+/, '  ')
  end

  def run
    puts IO.popen(render, &:read)
  end
end

module Kernel
  def basename(f, ext='.*')
    File.basename(f, ext)
  end
  alias :ts :TStamp
end

f, *pairs = ARGV


unless f
  f = [File.basename(Dir.pwd),'.ffmpeg'].join
  File.write(f, 'ffmpeg {i} {basename(i)}')
  raise ['use template: ', f].join
end

params=pairs.each_slice(2).to_a.to_h
FFMpeg.new(f, **params)
.tap{|o| puts o.cmd}
.run
