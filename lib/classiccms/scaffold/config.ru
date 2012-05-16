#require 'bundler'
#Bundler.setup
#Bundler.require(:default, ENV['RACK_ENV'].to_sym)
ClassicCMS::Application


run Rack::URLMap.new({
  '/'          => WebsitesController,
  '/cms'       => CMSController,
  '/code'      => CodeController
})
