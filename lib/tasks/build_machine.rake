require 'rubygems'
require 'rake'
require 'fileutils'
require 'bundler' 

desc "Task for the build machine"
task :continuous_integration do
  `rake db:migrate`
  `rake spec`                     
end  
