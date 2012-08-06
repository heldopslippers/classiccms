module Classiccms
  class AdminController < ApplicationController
    include Classiccms::Routing
    register Sinatra::MultiRender

    set :multi_views,   [File.join(Classiccms::ROOT, 'views/admin'), File.join(Classiccms::ROOT, 'public')]
    set :root, Dir.pwd
    set :public_folder, Proc.new { File.join(Classiccms::ROOT, 'public/admin') }

    get '/' do
      show 'index'
    end
    get '/destroy/:model' do
      if Classiccms::CONFIG[:admin].include? params[:model]
        @model = params[:model].constantize
        @model.all.destroy
        redirect to "/#{params[:model]}}"
      end
    end
    get '/:model' do
      if Classiccms::CONFIG[:admin].include? params[:model]
        @model = params[:model].constantize
        @records = @model.all
        show 'index'
      end
    end
  end
end
