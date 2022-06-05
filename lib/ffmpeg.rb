#!/usr/bin/env ruby
# Id$ nonnax 2022-06-05 11:35:55 +0800
require 'fileutils'
require 'mote'

class HString<SimpleDelegator
  def to_str
    inject([]){|acc, (k,v)|
      acc << 
        if v.respond_to?(:assoc) 
          repeat k, v 
        else
          format "-%s %s", k, v 
        end
    }.join ' '
  end
  alias to_s to_str
  
  def repeat(k, v)
    v.inject(''){|str, e|
      str<<format( "-%s %s", k, e )
    }
  end
end

class FFMpeg
  attr :path, :basename, :ext, :method
  def initialize(path=nil)
    @path=path
    @basename, _, @ext = @path.dup.rpartition('.')
    @opts = { q:5, preset:'slow' }
    @standard_opts = HString.new(@opts)
  end

  def tempfile
    @tempfile=File.join([@method, @basename.tr('/','_'), @ext].compact.join('.'))
  end

  def cut(ss:nil, to:nil, ext:nil, extra:'')
    @method=__method__
    @ext=ext if ext

    @cmd="ffmpeg -i '#{@path}'"
    @cmd<<" -ss #{ss}" if ss
    @cmd<<" -to #{to}" if to
    @cmd<<@standard_opts
    @cmd<<" #{extra} {{tempfile}}"
    self
  end

  def crop(in_w:3, extra:'-preset veryslow')
    @method=__method__
    @cmd= "ffmpeg -i '#{@path}' -filter:v 'crop=in_w/#{in_w}:in_h:in_w/#{in_w}:0'"
    @cmd<< @standard_opts
    @cmd<< " #{extra} {{tempfile}}"
    self
  end
  
  def get_audio(ext:'wav', extra:'-vn')
    cut(ext:, extra:)
    @method=__method__
    self
  end
  
  def get_video(ext:nil, extra:'-an')
    cut(ext:, extra: )
    @method=__method__
    self
  end
   
  def add_audio(audio:nil, ext:nil, extra:'')
    @method=__method__
    @cmd="ffmpeg -i '#{@path}' -i '#{audio}' -c:v copy #{extra} #{tempfile}"
    @cmd<<' '+ext if ext
    self
  end

  def blur(radius:5)
    @method=__method__
    @cmd=<<~___
      ffmpeg -i '#{@path}' -filter_complex 
        '[0:v]boxblur=luma_radius=#{radius}:chroma_radius=#{radius}:luma_power=1[blurred]' 
        -map '[blurred]' -map 0:a '{{tempfile}}'
    ___
    self
  end
  
  def fadein(duration:5)
    @method=__method__
    @cmd=<<~___
      ffmpeg -i '#{@path}' -filter_complex 
        '[0:v]fade=type=in:start_time=1:duration=#{duration}[fadein]' 
        -map '[fadein]' -map 0:a '{{tempfile}}'
    ___
    self
  end

  def render
    cmd do |c|
      IO.popen(c.gsub(/\n/,' '), &:read) 
    end
    FFMpeg.new(@tempfile)
  end

  def cmd
    return unless defined?(@cmd)
    mote=Mote.parse(@cmd, self, [:tempfile])
    yield @cmd=mote.call(tempfile: )  
  end

  def save
    @tempfile.then{|tf| FileUtils.mv( tf, '.')}
  end


  def self.audio_pitch(f, pitch:5)
    outputf="#{pitch}_#{f}"
    cmd="rubberband -p #{pitch} #{f} #{outputf}"
    IO.popen(cmd, &:read)
    FFMpeg.new(outputf)
  end
  
end

__END__

require_relative 'ffmpeg'
# ffmpeg -i Automata.2014.720p.BluRay.x264.YIFY.mp4 -ss 00:24:19.750 -to 00:26:19.792 -an automata.mp4
# ffmpeg -i Automata.2014.720p.BluRay.x264.YIFY.mp4 -ss 00:24:19.750 -to 00:26:19.792 -vn automata.wav

ff=FFMpeg.new('Automata.2014.720p.BluRay.x264.YIFY.mp4')
# ff=FFMpeg.new('cut_Automata.2014.720p.BluRay.x264.YIFY.mp4')

newvid=
  ff.cut(ss:'00:24:19.750', to:'00:24:29.792').render
# ff.blur.render.fadein.render

aud, vid = newvid.get_audio.render, newvid.get_video.render
  
vid.add_audio(audio: FFMpeg.audio_pitch(aud.path, pitch:8).path ).render


def h
  { i: %w[ina.mp4 inb.mp4], 
    ss: 300, 
    'c:a': 'copy', 
    map: '1:a' }
end

def ffmpeg(output:'')
   h = yield 
   [__method__, HString.new(h), output].join(' ')
end

res=
ffmpeg output:'out.mp4' do
  h
end

p res
