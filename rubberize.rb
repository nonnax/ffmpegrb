#!/usr/bin/env ruby
# Id$ nonnax 2022-08-10 10:25:23
require 'json'
require 'ffmpeg/ffmpeg'
# `ffmpeg -i Archive_81_Season_1_Episode_1_Mystery_Signals_Full_HD_online.mp4 -ss 00:24:19.750 -to 00:26:19.792 -an automata.mp4`
# `ffmpeg -i Archive_81_Season_1_Episode_1_Mystery_Signals_Full_HD_online.mp4 -ss 00:24:19.750 -to 00:26:19.792 -vn automata.wav`
conf=JSON.parse(File.read('rubberize.json'), symbolize_names:true)
# create instance from input file
ff=FFMpeg.new(conf[:file])
# ff=FFMpeg.new('cut_Automata.2014.720p.BluRay.x264.YIFY.mp4')

# `cut` method 
# add `ss` starttime and `to` endtime 
# `render` creates a new file and returns a new ffobject  
newvid=
  ff
  .cut(ss:conf[:ss], to:conf[:to])
  .render
# ff.blur.render.fadein.render

# 
# `get_audio` method extracts entire audio-only. returns an FFMpeg object 
aud= 
  newvid
  .get_audio
  .render
# `get_video` method extracts entire video-only. returns an FFMpeg object
vid= 
  newvid
  .get_video
  .render

# 
# `path` method returns the os path of an ffobject
# `#audio_pitch` class method. takes a file path and pitch:8 modify audio of the file.
rubber_audio=FFMpeg.audio_pitch(aud.path, pitch:conf[:pitch])

# `add_audio!` method to mux an audio track onto a video file. 
# the original video file is updated in-place.
vid.add_audio!(audio: rubber_audio.path ).render

