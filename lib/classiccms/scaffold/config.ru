require 'rubygems'
require 'bundler'

Bundler.require
Classiccms.boot

use Dragonfly::Middleware, :file
run Rack::URLMap.new({
  '/'    => Classiccms::WebsiteController,
  '/cms' => Classiccms::CMSController,
  '/admin'  => Classiccms::AdminController,
  '/form'  => Classiccms::FormController,
})
