# ffmpegrb

The range of the CRF scale is 0–51, where 0 is lossless (for 8 bit only, for
10 bit use -qp 0), 23 is the default, and 51 is worst quality possible. A lower
value generally leads to higher quality, and a subjectively sane range is
17–28. Consider 17 or 18 to be visually lossless or nearly so; it should look
the same or nearly the same as the input but it isn't technically lossless.

The range is exponential, so increasing the CRF value +6 results in roughly
half the bitrate / file size, while -6 leads to roughly twice the bitrate.

Choose the highest CRF value that still provides an acceptable quality. If the
output looks good, then try a higher value. If it looks bad, choose a lower
value.

Note: The 0–51 CRF quantizer scale mentioned on this page only applies to
8-bit x264. When compiled with 10-bit support, x264's quantizer scale is 0–63
(internally in x264 itself it is from -12 to 51
​https://code.videolan.org/videolan/x264/-/blob/master/x264.c#L733 but ffmpeg
libx264 wrapper shifted it, so that 0 is lossless, but only in supported
profiles, High 10 does not support lossless). You can see what you are using by
referring to the ffmpeg console output during encoding (yuv420p or similar for
8-bit, and yuv420p10le or similar for 10-bit). 8-bit is more common among
distributors.

https://trac.ffmpeg.org/wiki/Encode/H.264
