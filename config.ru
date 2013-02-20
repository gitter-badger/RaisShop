# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run RaisShop::Application

#if Rails.env.development?
  #use Rack::RubyProf, path: 'tmp/profile'
#end
