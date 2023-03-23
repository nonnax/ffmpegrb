#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2022-11-07 21:46:20
require 'forwardable'

class FFMpeg
  # basic ffmpeg dsl
  attr :files, :stream_name_get

  def initialize
    @build = ['ffmpeg']
    @files = []
  end

  def self.go(&block)
    new.instance_eval(&block).to_s
  end

  def i(*a)
    @files += a
    @build << a.map { |e| format('-i %p', e) }.join(' ')
  end

  def out(f)
    @build << "'#{f}'"
    self
  end

  def filter_complex(**_options, &block)
    @build << FilterComplex.new(self, files: @files, &block).to_s
  end

  def maps(&block)
    @build << block.call
  end

  def stream_name_set(*names)
    @stream_name_get = names.map { |e| '[%s]' % e }
  end

  def to_s
    @build.join(' ')
  end

  def method_missing(m, *a, **_params)
    @build << format('-%s %s', m, a.join)
  end
end

class FilterComplex
  # parent methods shared
  extend Forwardable
  def_delegators :@parent, :files, :stream_name_set
  attr_accessor :options

  def initialize(parent, **options, &block)
    @parent = parent
    @block = block
    @builder = []
    @options = options
  end

  def stream_map(mapname, &block)
    @options[mapname] = files.size.times.map(&block)
    @builder << @options[mapname]
  end

  def add(&block)
    @builder << block.call
  end

  def stream_name_set(*a)
    add { @parent.stream_name_set(*a) }
  end

  def to_s
    instance_exec(self, &@block)
    format("-filter_complex '%s'", @builder.flatten.join(' '))
  end

  def filter(type, **pairs)
    @builder << "#{type}=" + pairs.map { |k, v| format('%s=%s', k, v) }.join(':')
  end
end

# candy method
def FFMpeg(&block)
  FFMpeg.go(&block)
end

__END__
a=FFMpeg do
 ss '00:01'
 to '00:05'
 i 'hallo.txt'

 ss '00:11'
 to '00:15'
 i 'hey.txt'
 i 'haha.txt', 'hoho.txt'

 filter_complex{
    stream_map(:map_av){|i| format("[v:%s]", i)}
    stream_map(:map_streams){|i| format('[%d:v][%d:a]', i, i)}
    filter(:concat, n:files.size, v:1, a:2)
    stream_name_set :v, :a1, :a2
    # p self
 }

 c :copy
 maps{ stream_name_get.map{|e| format "-map '%s'", e} }
 out files.map{|f| p File.basename(f, '.*')}.join+stream_name_get.join+'.wakaka'
end

puts a

