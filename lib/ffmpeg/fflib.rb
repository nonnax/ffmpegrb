#!/usr/bin/env ruby
# Id$ nonnax 2022-01-21 14:54:29 +0800
RESOLUTIONS =
%w[
 426:240 
 640:360 
 720:480 
 1280:720 
 1920:1080
 2560:1440
 3840:2160
]

names = RESOLUTIONS.map do |e| 
  e
  .split(':')
  .last + 'p'
end

SCALES = names.zip(RESOLUTIONS).to_h

PRESETS =
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
]

# 
# Constant Rate Factor (CRF)
# 
# Use this mode if you want to retain good visual quality and don't care about 
# the exact bitrate or filesize of the encoded file. The mode works exactly the
# same as in x264, except that maximum value is always 51, even with 10-bit
# support, so please read the H.264 guide for more info.
# 
# As with x264, you need to make several choices:
# 
# Choose a CRF. CRF affects the quality. The default is 28, and it should 
# visually correspond to libx264 video at CRF 23, but result in about half the
# file size. CRF works just like in x264, so choose the highest value that
# provides an acceptable quality.
# 
# Choose a preset. The default is medium. The preset determines compression 
# efficiency and therefore affects encoding speed. Valid presets are ultrafast,
# superfast, veryfast, faster, fast, medium, slow, slower, veryslow, and placebo.
# Use the slowest preset you have patience for. Ignore placebo as it provides
# insignificant returns for a significant increase in encoding time.
# 
# Choose a tune (optional). By default, this is disabled, and it is 
# generally not required to set a tune option. x265 supports the following -tune
# options: psnr, ssim, grain, zerolatency, fastdecode. They are explained in the
# H.264 guide.
# 
# For example:
# 
# ffmpeg -i input -c:v libx265 -crf 26 -preset fast -c:a aac -b:a 128k output.mp4
# 
# This example uses AAC audio at 128 kBit/s. This uses the native FFmpeg AAC 
# encoder, but under AAC you will find info about more options.
# Valid sizes:
# 240p, 360p, 480p, 720p,
# 1080p, 1440p, 2160p
# 
# # 3840 x 2160 (or 2160p)
# # 2560 x 1440 (or 1440p)
# # 1920 x 1080 (or 1080p)
# # 1280 x 720 (or 720p)
# # 854 x 480 (or 480p)
# # 720 x 480 (or 480p)
# # 640 x 360 (or 360p)
# # 426 x 240 (or 240p)
# # 320 x 240 (or 240p)
# 
# Valid presets are :
# 
# ultrafast, superfast, veryfast, faster, fast,
# medium, slow, slower, veryslow, and placebo.
# 
# Use the slowest preset you have patience for.
