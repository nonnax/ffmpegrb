#!/usr/bin/env ruby
# Id$ nonnax 2022-08-10 11:25:29

class FFMpeg

  def crop(in_w:3, extra:'-preset veryslow')
    @method=__method__
    @cmd= "ffmpeg -i '#{@path}' -filter:v 'crop=in_w/#{in_w}:in_h:in_w/#{in_w}:0'"
    @cmd<< @standard_opts
    @cmd<< " #{extra} {{tempfile}}"
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

  def get_frames(**opts)   
    outdir='frames'
    params={
      fps: 60,
      per_second: 0.5,
      scale: '1280:360'
    }.merge(opts)

    help[__method__]=<<~___
        # usage:
        params = #{params}
        #{__method__}( params )
    ___

    return help[__method__] if params[:help]

    FileUtils.mkdir(outdir) unless Dir.exist?(outdir)

    params[:path] = @path    
    params[:timeframe] = params[:fps]*params[:per_second]    
    
    cmd = %q(ffmpeg -i {{path}} -qscale:v 2 -vf "select='not(mod(n,{{timeframe}}))',setpts='N/({{fps}}*TB)',scale='{{scale}}'" -f image2 frames/frame_%04d.jpg 2>&1)

    t = Mote.parse(cmd, self, params.keys)[params]
    IO.popen( t, &:readlines).select{|e| (/input|output|stream/i).match?(e) }  
  end
  

  def cat_frames(**opts)
    params={
        rate:60,
        crf:20,
        mp4:'frames_outfile',
        scale: '1280:360'
    }.merge(opts)

    help[__method__]=<<~___
        # usage:
        params = #{params}
        #{__method__}( params )
    ___

    return help[__method__] if params[:help]
  
    cmd = 'ffmpeg -r {{rate}} -i frames/frame_%04d.jpg -c:v libx264 -pix_fmt yuv420p -crf {{crf}} -r {{rate}} -vf scale="{{scale}}"  -y {{mp4}}.mp4 2>&1'

    t=Mote.parse(cmd, self, params.keys)[params]

    pp IO.popen(t, &:readlines).select{|e| (/input|output|stream/i).match?(e) }
  
  end

end
