require "mongoid"
require 'haml'
require 'sinatra/base'
require 'sinatra/support'
require "sinatra"
require 'thin'
require 'tilt'
require "tilt"
require "haml"
require "sass"
require "slim"
require "coffee-script"
require 'encryptor'
require 'resque'
require 'resque/server'
require 'dragonfly'

$app = Dragonfly[:image]
$app.define_macro_on_include(Mongoid::Document, :image_accessor)
$app.configure_with(:imagemagick)

CONFIG = {}
module Classiccms
  ROOT = File.dirname(__FILE__)
  def self.boot
    #registrer cms special types
    require File.join(File.dirname(__FILE__), 'custom.rb')

    #In order to get css and js files to "render"
    Tilt.register Tilt::ERBTemplate, 'css'
    Tilt.register Tilt::ERBTemplate, 'js'

    #encryption
    Encryptor.default_options.merge!(:key => 'zC8+;[nMXYKMcTIKV93P$d621yKNYVRpTCv1,sU<`*I<C6?f6UZ)>f0o`-SP~of')

    #FROM Gem
    #require lib files
    Dir[File.join(File.dirname(__FILE__), 'lib/*.rb')].each {|file| require file }

    #FROM App
    #Set config.yml
    if !defined? CONFIG or CONFIG.empty? and ENV['RACK_ENV'] != 'test'
      value = YAML.load_file(File.join(Dir.pwd, 'config/config.yml'))[ENV['RACK_ENV']]
      const_set "CONFIG", value.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    end

    #FROM App
    #require Application file
    require File.join(Dir.pwd, 'config/application') #if File.exist?(File.join(Dir.pwd, 'config/application'))


    #From gem
    #require models
    Dir[File.join(File.dirname(__FILE__), 'models/*.rb')].each {|file| require file }

    #FROM App
    #require models
    Dir[File.join(Dir.pwd, 'app/models/*.rb')].each {|file| require file }

    #FROM App
    #require mongoid
    Mongoid.load!(File.join(Dir.pwd, 'config/mongoid.yml'))

    $app.configure do |d|
      d.url_format = '/assets/:job'
    end
    $app.datastore.configure do |d|
      d.root_path = File.join(Dir.pwd, 'assets')
    end

    #from gem
    #require resque
    redis_conf = YAML.load_file(File.join(Dir.pwd, 'config/redis.yml'))[ENV['RACK_ENV']]
    Resque.redis = redis_conf
    Resque.redis.namespace = redis_conf[:database]

    #require helpers
    require File.join(File.dirname(__FILE__), 'helpers.rb')

    #FROM App
    #require queue
    Dir[File.join(Dir.pwd, 'app/queue/*.rb')].each {|file| require file }

    #FROM Gem
    #require controllers
    Dir[File.join(File.dirname(__FILE__), 'controllers/*.rb')].each {|file| require file }

    #FROM App
    #require controllers
    Dir[File.join(Dir.pwd, 'app/controllers/*.rb')].each {|file| require file }
  end
end
