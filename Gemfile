source 'http://rubygems.org'

gem 'rails', '3.0.9'
gem 'sqlite3'
gem 'rake', '0.9.2.2'

#Heroku
gem 'heroku'
gem 'taps'
gem 'pg'

#GEMS FOR Development and Testing
#These WILL NOT be pushed to Heroku
#$heroku = ENV['USER'] ? !! ENV['USER'].match(/^repo\d+/) : ENV.any?{|key, _| key.match(/^HEROKU_/)} 


#unless $heroku
  group :development, :test do
     gem 'webrat' #added for rspec
     gem 'rspec-rails'
     gem 'ruby-debug19' 
     gem 'ruby-debug-base19x' 
     gem 'ruby-debug-ide'
  end
#end

#suggested gems by Todd
gem 'jquery-rails', '>= 1.0.3'
#gem 'jquery-rails', '>= 1.0.12'
gem 'factory_girl_rails' 
gem 'devise' 

#Paperclip
gem "paperclip", "~> 2.4"

#active admin
gem 'activeadmin'

gem "dynamic_form"

#Scheduling ("cron job") for bid winning
gem "rufus-scheduler"


#----------------
# Below gems were already in gem file when downloaded from GitHub
# They are all commeted out, as they are just for reference.
# If you would like to use one, please add it above.
#-----------------

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

#gem "whenever", :require => false
#gem 'iso-3166-country-select', :git => 'git://github.com/rails/iso-3166-country-select.git'
#gem 'country_select', :git => 'git://github.com/jodosha/country_select.git'
#gem 'iso-3166-country-select'
#gem 'country-select'
