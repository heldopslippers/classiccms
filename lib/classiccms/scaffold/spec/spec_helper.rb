require 'rubygems'
require 'bundler/setup'

#set environment to test
ENV['RACK_ENV'] = 'test'

#include app
require 'classiccms/application'
Classiccms.boot

#include sinatra end set environment
#require 'rack/test'
require 'sinatra'

set :environment, :test

RSpec.configure do |config|

  config.before(:each) do
  	Mongoid.master.collections.reject { |c|  c.name =~ /^system./ }.each(&:drop)
  end
 # config.include Rack::Test::Methods
end

