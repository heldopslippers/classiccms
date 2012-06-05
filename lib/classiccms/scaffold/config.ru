require 'rubygems'
require 'bundler'

Bundler.require

ENV['RACK_ENV'] = 'development'
Classiccms.boot


run Rack::URLMap.new({
  '/'    => Classiccms::WebsiteController,
  '/cms' => Classiccms::CMSController,
  '/form'  => Classiccms::FormController
})
