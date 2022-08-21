#!/usr/bin/env ruby
# Id$ nonnax 2022-06-05 11:35:55 +0800
require 'fileutils'
require 'delegate'
require 'mote'

# `HString` class 
# converts a hash into a `-option` `value` formatted string
#  
class HString<SimpleDelegator

  def to_str
    inject([]){|acc, (k,v)|
      acc << 
        if v.respond_to?(:assoc) 
          repeat k, v 
        else
          format " -%s %s ", k, v 
        end
    }.join(' ') #.tr('true', '') #.split.join(' ')
  end
  alias to_s to_str
  
  def repeat(k, v)
    v.inject(''){|str, e|
      str<<format( " -%s %s ", k, e )
    }
  end
end

class FFMpeg
  attr :path, :basename, :ext, :method, :help

  def initialize(path=nil)
    @path=path
    @basename, _, @ext = @path.dup.rpartition('.')
    @opts = {  crf:20, preset:'slow' }
    @standard_opts = HString.new(@opts)
    @help = Hash.new
  end

  def tempfile
    @tempfile=File.join([@method, @basename.tr('/','_'), @ext].compact.join('.'))
  end

  # `cut` method 
  # add `ss` starttime and `to` endtime 
  # send `render` to execute os command
  def cut(ss:nil, to:nil, ext:nil, extra:'')
    @method=__method__
    @ext=ext if ext

    @cmd="ffmpeg -i '#{@path}' "
    @cmd<<" -ss #{ss} " if ss
    @cmd<<" -to #{to} " if to
    @cmd<<@standard_opts
    @cmd<<" #{extra} {{tempfile}}"
    self
  end
  
  def get_audio(ext:'wav', extra:' -vn')
    cut(ext:, extra:)
    @method=__method__
    self
  end
  
  # def get_video(ext:'mp4', extra:'-an -pix_fmt yuv420p -f yuv4mpegpipe -frames:v 25 ')
  def get_video(ext:'mp4', extra:' -an -pix_fmt yuv420p')
    cut(ext:, extra: )
    @method=__method__
    self
  end
   
  def add_audio!(audio:nil, ext:nil, extra:'')
    @method=String(__method__).tr!('!','_')
    @cmd=%{
      ffmpeg -i '#{@path}' 
      -i '#{audio}' 
      -c:v copy #{extra} 
      #{tempfile}
    }
    @cmd.gsub!(/\n{1,}, ' '/)
    @cmd<<' '+ext if ext
    self
  end

  def render
    res=cmd do |c|
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
    outputf="#{ String( pitch ).tr('-', 'neg_') }_#{ f }"
    cmd="rubberband -p #{pitch} #{f} #{outputf}"
    IO.popen(cmd, &:read)
    FFMpeg.new(outputf)
  end

  def self.ffmpeg(output:'', **h)
     [__method__, HString.new(h), output].join(' ')
  end

  
  def get_fps
    info=IO.popen "ffprobe -show_entries format=duration #{@path} 2>&1", &:readlines
    info.select{|e| /Stream/.match?(e)}.map(&:strip).join("\n")
  end
  
end

__END__

# require_relative 'ffmpeg'
# # ffmpeg -i Automata.2014.720p.BluRay.x264.YIFY.mp4 -ss 00:24:19.750 -to 00:26:19.792 -an automata.mp4
# # ffmpeg -i Automata.2014.720p.BluRay.x264.YIFY.mp4 -ss 00:24:19.750 -to 00:26:19.792 -vn automata.wav
# 
# # create instance from input file
# ff=FFMpeg.new('Automata.2014.720p.BluRay.x264.YIFY.mp4')
# # ff=FFMpeg.new('cut_Automata.2014.720p.BluRay.x264.YIFY.mp4')
# 
# # `cut` method
# # add `ss` starttime and `to` endtime
# # `render` creates a new file and returns a new ffobject
# newvid=
  # ff.cut(ss:'00:24:19.750', to:'00:24:29.792').render
# # ff.blur.render.fadein.render
# 
# #
# # `get_audio` method extracts entire audio-only
# # `get_video` method extracts entire video-only
# #
# aud, vid = newvid.get_audio.render, newvid.get_video.render
# 
# #
# # `add_audio` method to mux an audio track onto a video file. video file is updated in-place.
# # `path` method returns the os path of an ffobject
# # `#audio_pitch` class method. takes a file path and pitch:8 modify audio of the file.
# 
# vid.add_audio!(audio: FFMpeg.audio_pitch(aud.path, pitch:8).path ).render


# def h
  # { i: %w[ina.mp4 inb.mp4],
    # ss: 300,
    # 'c:a': 'copy',
    # map: '1:a' }
# end

def ffmpeg(output:'', **h)
   # h = yield
   [__method__, HString.new(h), output].join(' ')
end

res=
ffmpeg output:'out.mp4',     
    i: %w[ina.mp4 inb.mp4], 
    ss: 300, 
    'c:a': 'copy', 
    map: ['1:a', '0:v'],
    an: true,
    vn: true 

p res
