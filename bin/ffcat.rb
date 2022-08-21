#!/usr/bin/env ruby
# Id$ nonnax 2022-08-21 16:39:19
require 'rbcat'
f, = ARGV

# $/= "\n\n"

description=File.read(f)

description.gsub!(/\n/, ' ').split.join(' ')

rules = {
  brackets:{
    regexp: /[\(\)\[\]]/m,
    color: :bright_yellow
  },
  flags: {
    regexp: /(?:\s)\-\w+/,
    color: :bold_blue
  },
  inside_quotes: {
    regexp: /['"]/m,
    color: :bold_yellow
  },
}

puts Rbcat.colorize(description, rules: rules)
