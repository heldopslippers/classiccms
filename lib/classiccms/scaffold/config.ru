require 'rubygems'
require 'bundler'

Bundler.require
Classiccms.boot


run Rack::URLMap.new({
  '/'    => Classiccms::WebsiteController,
  '/cms' => Classiccms::CMSController,
  '/form'  => Classiccms::FormController
})
