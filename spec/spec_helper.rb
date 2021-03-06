require 'rubygems'
require 'bundler/setup'

#set environment to test
ENV['RACK_ENV'] = 'test'

require 'classiccms/application'
require 'methods'

#factory girl
require 'factory_girl'
FactoryGirl.find_definitions

#include sinatra end set environment
require 'rack/test'
require 'sinatra'

set :environment, :test

RSpec.configure do |config|
  Mongoid.load!("spec/config/mongoid.yml", :test)

  config.before(:each) do
  	Mongoid.default_session.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  #for storing default settings during testing
  $default = {}
  $default[:dir] = Dir.pwd
end
