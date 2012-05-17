require 'classiccms/application'

ENV['RACK_ENV'] = 'development'
Classiccms.boot


run Rack::URLMap.new({
  '/'          => Classiccms::WebsiteController,
  '/cms'       => Classiccms::CMSController,
})
