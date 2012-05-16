require 'classiccms/controllers/application'

module Classiccms
  class WebsiteController < ApplicationController
    set :multi_views,   [ File.join(Dir.pwd, 'views')]
    set :root, Dir.pwd
    set :public_folder, Proc.new { File.join(Dir.pwd, 'public') }

    get '/' do
      response.headers['Cache-Control'] = 'no-cache'

      index = CONFIG[:home].kind_of?(String) ? CONFIG[:home] : 'application/index'
      @routes = get_route(get_first_item)
      show index
    end
    get '/js/*.js' do
      response.headers['Cache-Control'] = ENV['RACK_ENV'] == 'development' ? 'no-cache' : 'public, max-age=86400'
      show params[:splat].join, :views => [File.join(Dir.pwd, 'assets/js')]
    end
    get '/css/*.css' do
      response.headers['Cache-Control'] = ENV['RACK_ENV'] == 'development' ? 'no-cache' : 'public, max-age=86400'
      show params[:splat].join, :views => [File.join(Dir.pwd, 'assets/css')]
    end
    get '/:id/?*' do
      response.headers['Cache-Control'] = 'no-cache'
      pass unless Slug.exists?(conditions: {_id: params[:id]})
      index = CONFIG[:home].kind_of?(String) ? CONFIG[:home] : 'application/index'

      item = Base.find(Slug.find(params[:id]).document_id)
      @routes = get_route(item)
      show index
    end
  end
end
