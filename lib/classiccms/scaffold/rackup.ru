require File.dirname(__FILE__) + '/config/boot.rb'
require 'bundler'
Bundler.setup
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require 'resque/server'


run Rack::URLMap.new({
  '/'          => WebsitesController,
  '/cms'       => CMSController,
  '/admin'     => AdminController,
  '/code'      => CodeController,
  '/resque'    => Resque::Server.new
})
