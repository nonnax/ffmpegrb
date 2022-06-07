#!/usr/bin/env ruby
# Rakefile
# ---------cut-----------

task default: %w[build]

desc "Bundle install dependencies"
task :bundle do
  sh "bundle install"
end

desc "Build the ffmpegrb.gem file"
task build: %w[bundle] do
  sh "gem build ffmpegrb.gemspec"
end

desc "install ffmpegrb-x.x.x.gem"
task install: %w[build] do
  sh "sudo gem install $(ls ffmpegrb-*.gem)"
end
