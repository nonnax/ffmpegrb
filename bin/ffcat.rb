#!/usr/bin/env ruby
# Id$ nonnax 2022-08-21 16:39:19
require 'rbcat'
f, = ARGV

# $/= "\n\n"

description=File.read(f)

a, b = description.split(/\n{2,}/)

a1=a.split(/\s(?:;)?/).join(" ").split.join(' ')
b1=b.split(/\s(?:;)?/).join(" ").split.join(' ')

description = [a1, b1].join("\n\n")

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
