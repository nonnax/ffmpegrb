#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2021-10-08 14:20:26 +0800
require 'fzf'

inf = Dir['*.mp4'].fzf(cmd: "fzf --prompt='input video file'").first
watermark = Dir['*.png'].fzf(cmd: "fzf --prompt='watermark png'").first

res = %w[1920 1280].fzf.first.to_i
imgwidth = IO.popen( %{identify -format '%wx%h' #{watermark}), &:read }
						.split('x')
						.first&
						.to_i
imgwidth ||= 150
overlay_x = res - imgwidth

cmd = []
cmd << 'ffmpeg'
cmd << "-i '#{inf}' -i '#{watermark}'"
cmd << "-filter_complex 'overlay=x=#{overlay_x+1}:y=1'"
cmd << "vwm_#{inf}"

p cmd
IO.popen(cmd.join(' '), &:read)
