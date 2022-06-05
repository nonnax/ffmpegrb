#!/usr/bin/env ruby
# Id$ nonnax 2022-06-05 11:35:55 +0800
require 'fileutils'

class FFMpeg
  attr :file
  def initialize(file=nil)
    @file=file
  end

  def inspect
    @tempfile
  end

  def tempfile
    @tempfile=File.join([@type, _basename(@file), @ext].compact.join('_'))
  end

  def _basename(f)
    File.basename(f)
  end

  def cut(ss:nil, to:nil, ext:nil, extra:'')
    @type=__method__
    @ext=ext

    @cmd="ffmpeg -i '#{@file}'"
    @cmd<<" -ss #{ss}" if ss
    @cmd<<" -to #{to}" if to
    @cmd<<" #{extra} #{tempfile}"
    self
  end

  def get_audio(ext:'.wav', extra:'-vn')
    cut(ext:, extra:)
    @type=__method__
    self
  end
  
  def get_video(ext:nil, extra:'-an')
    cut(ext:, extra: )
    @type=__method__
    self
  end
   
  def add_audio(audio:nil, ext:nil, extra:'')
    @type=__method__
    # @cmd="ffmpeg -i '#{@file}' -ss #{ss} -to #{to} #{extra} #{tempfile}"
    @cmd="ffmpeg -i '#{@file}' -i '#{audio}' -c:v copy #{extra} #{tempfile}"
    @cmd<<' '+ext if ext
    self
  end

  def blur(radius:5)
    @type=__method__
    @cmd=<<~___
      ffmpeg -i '#{@file}' -filter_complex 
        '[0:v]boxblur=luma_radius=#{radius}:chroma_radius=#{radius}:luma_power=1[blurred]' 
        -map "[blurred]" -map 0:a '#{tempfile}'
    ___
    self
  end
  
  def fadein(duration:5)
    @type=__method__
    @cmd=<<~___
      ffmpeg -i '#{@file}' -filter_complex 
        '[0:v]fade=type=in:start_time=1:duration=#{duration}[fadein]' 
        -map '[fadein]' -map 0:a '#{tempfile}'
    ___
    self
  end


  def render
    p @cmd
    IO.popen(@cmd.gsub(/\n/,' '), &:read) if @cmd
    p FFMpeg.new(@tempfile)
  end
  
  def save
    @tempfile.then{|tf| FileUtils.mv( tf, '.')}
  end


  def self.audio_pitch(f, pitch:5)
    outputf="#{pitch}_#{f}"
    cmd="rubberband -p #{pitch} #{f} #{outputf}"
    IO.popen(cmd, &:read)
    outputf
  end
  
end
