
module Classiccms
  class AdminController < ApplicationController
    include Classiccms::Routing
    register Sinatra::MultiRender

    set :multi_views,   [File.join(Classiccms::ROOT, 'views/admin'), File.join(Classiccms::ROOT, 'public')]
    set :root, Dir.pwd
    set :public_folder, Proc.new { File.join(Classiccms::ROOT, 'public/admin') }
    before do
      pass if @user != nil
      redirect '/login'
    end

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
    get '/all/:model' do
      content_type 'text/plain'
      csv = ''
      fields = []
      @model = params[:model].constantize
      @model.fields.each do |key, info| 
        if !["_type", "_id", "created_at", "updated_at", "version", "deleted_at"].include? key    
          fields << key
          csv +=  key + ','
        end
      end
      csv += "\n"

      @model.all.each do |i|
        fields.each do |key|
          csv += i[key].to_s + ','
        end
        csv += "\n"
      end
      return csv
    end

    get '/load' do

      if Classiccms::CONFIG[:admin].include? params[:model]
        @model = params[:model].constantize
        fields = []
        search = []
        @model.fields.each do |key, info| 
          if !["_type", "_id", "created_at", "updated_at", "version", "deleted_at"].include? key
            fields << key
            search << {key => /^.*#{params[:sSearch]}.*/i}
          end
        end
        
        @records = @model.any_of(search).order_by([fields[params[:iSortCol_0].to_i], params[:sSortDir_0]])[params[:iDisplayStart].to_i, params[:iDisplayStart].to_i + params[:iDisplayLength].to_i]
        result = {"sEcho" => params['sEcho'], "iTotalRecords" => @model.all.count, "iTotalDisplayRecords" => @model.all.count, "aaData" => []}
        result['aaData'] = @records.map do|i| 
          items = []
          fields.each do |key| 
            items << i[key] == nil ? "" : i[key]            
          end
          items << edit(i.id).to_a
        end
        return result.to_json
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
