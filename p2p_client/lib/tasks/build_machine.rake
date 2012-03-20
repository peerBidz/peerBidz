require 'rubygems'
require 'rake'
require 'fileutils'
require 'bundler' 

desc "Task for the build machine"
task :continuous_integration  => ['git_clean', 'db:migrate', 'spec']

task :git_clean do
  system 'git checkout db/schema.rb'
  system 'git checkout Gemfile.lock'
end 
