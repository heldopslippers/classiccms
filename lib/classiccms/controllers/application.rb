require 'haml'
require 'sinatra/base'
require 'sinatra/support'

module Classiccms
  class ApplicationController < Sinatra::Base
    include  Classiccms::Routing
    register Sinatra::MultiRender
    helpers  Classiccms::Helpers

    set :multi_views,   [ File.join(Dir.pwd, 'views')]
    set :root, Dir.pwd
    set :public_folder, Proc.new { File.join(Dir.pwd, 'public') }
    set :session_secret, '427a474a206b616e5c4f2a4f3c7d2d517e2a564e21556e24593363253e'

    enable :sessions

    before do
      if User.where(:_id => session[:user_id]).count > 0
        @user = User.find(session[:user_id]) if session[:user_id] != nil
      else
        session[:user_id] = nil
      end
    end

    get '/login' do
      show :login, views: File.join(Classiccms::ROOT, 'views/cms')
    end
    post '/login' do
      user = User.where(:username => params[:username], :password => params[:password]).first
      if user != nil
        session[:user_id] = user.id
        redirect to(params[:correct] != nil ? params[:correct] : '/')
      else
        redirect to(params[:incorrect] != nil ? params[:incorrect] : '/login')
      end
    end
    get '/logout' do
      session[:user_id] = nil
      redirect '/'
    end
  end
end
