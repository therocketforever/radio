require "bundler/setup"
Bundler.require(:default)

require File.expand_path('../lib/application', __FILE__)
require File.expand_path('../lib/api', __FILE__)

Environment = Sprockets::Environment.new
Environment.append_path 'lib/assets/css'
# The `//=` directives for 
#Environment.append_path 'lib/assets/js/libs'
Environment.append_path 'lib/assets/js/'
Environment.append_path 'lib/assets/img'
Environment.append_path 'lib/public'


puts "Environment: ".color(:blue) + "Online".color(:green)
run Rack::Cascade.new [API, Environment, Application]
puts "Radio Initialized @ #{Time.now}".color(:blue)