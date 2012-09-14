require 'classiccms/controllers/application'

module Classiccms
  class WebsiteController < ApplicationController
    set :multi_views,   [ File.join(Dir.pwd, 'app/views')]
    set :root, Dir.pwd
    set :public_folder, Proc.new { File.join(Dir.pwd, 'public') }

    get '/' do
      response.headers['Cache-Control'] = 'no-cache'

      index = CONFIG[:home].kind_of?(String) ? CONFIG[:home] : 'application/index'
      @routes = get_route(get_first_item)
      @routes << nil
      show index
    end
    get '/javascripts/*.js' do
      response.headers['Cache-Control'] = ENV['RACK_ENV'] == 'development' ? 'no-cache' : 'public, max-age=86400'
      content_type :js
      show params[:splat].join, :views => [File.join(Dir.pwd, 'public/javascripts')]
    end
    get '/stylesheets/*.css' do
      response.headers['Cache-Control'] = ENV['RACK_ENV'] == 'development' ? 'no-cache' : 'public, max-age=86400'
      content_type :css
      show params[:splat].join, :views => [File.join(Dir.pwd, 'public/stylesheets')]
    end
    get '/:id/?*' do
      response.headers['Cache-Control'] = 'no-cache'
      pass unless Slug.where(_id: params[:id]).exists?
      index = CONFIG[:home].kind_of?(String) ? CONFIG[:home] : 'application/index'


      item = Base.find(Slug.find(params[:id]).document_id)
      @routes = get_route(item)
      @routes << nil
      show index
    end

    
    not_found do
      show :'404', views: File.join(Classiccms::ROOT, 'views/cms')
    end
  end
end
