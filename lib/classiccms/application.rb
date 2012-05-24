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
require 'carrierwave/mongoid'

CONFIG = {}
module Classiccms
  ROOT = File.dirname(__FILE__)
  def self.boot
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

    #FROM Gem
    #require mongoid
    Mongoid.load!(File.join(ROOT, 'mongoid.yml'))

    #from gem
    #require resque
    Resque.redis = YAML.load_file(File.join(ROOT, 'resque.yml'))[ENV['RACK_ENV']]
    Resque.redis.namespace = CONFIG[:database]

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
