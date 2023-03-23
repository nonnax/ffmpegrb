#!/usr/bin/env ruby
# Id$ nonnax 2023-03-23 11:54:59 +0800
require 'texticle/texticle'
require 'time/time_ext'

class FFMpeg
  def initialize(f, **params)
    @template = File.read(f)
    @params = params
  end

  def to_s
    @cmd=Texticle.parse(@template, **@params).gsub(/\n+/, ' ')
  end

  def run
    puts IO.popen(@cmd, &:read)
  end
end

module Kernel
  def basename(f, ext='.*')
    File.basename(f, ext)
  end
end

f, *pairs = ARGV

params=pairs.each_slice(2).to_a.to_h
puts FFMpeg.new(f, **params)#.render(**params)
