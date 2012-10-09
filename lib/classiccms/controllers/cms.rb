require 'haml'
require 'sinatra/base'
require 'sinatra/support'

module Classiccms
  class CMSController < ApplicationController
    include Classiccms::Routing
    register Sinatra::MultiRender

    set :multi_views,   [File.join(Classiccms::ROOT, 'views/cms'), File.join(Classiccms::ROOT, 'public')]
    set :root, Dir.pwd
    set :public_folder, Proc.new { File.join(Classiccms::ROOT, 'public') }

    post '/add' do
      if params['cms'] != nil and params['cms'].length > 2
        begin
          params['cms'] = Base64.decode64(params['cms']).decrypt
          new_params= eval(params['cms'])
          records = []          
          if new_params.first.class != Array
            records << new_params.first.new
          else
            new_params.each do |new|
              record = new[0].new
              records.each do |i|
                if i.kind_of? new[0]
                  record = i
                  records.delete(i)
                end
              end
              files = new.length > 3 ? new[3..new.length] : [new[2]]
              record.connections << Connection.new(:parent_id => new[1], :section => new[2], :files => files)
              records << record
            end
          end
          show :add_window, {}, {:records => records}
        rescue TypeError, ArgumentError
          ''
        end
      end
    end
    post '/edit' do
      begin
        params['cms'] = Base64.decode64(params['cms']).decrypt
      rescue
        ''
      end
      records = Base.where(_id: params['cms'])
      if records.count > 0
        record = records.first
        show :add_window, {}, {:record => record}
      end
    end
    post '/destroy' do
      items = Base.where(_id: params[:id])
      items.first.destroy if items.count > 0
    end
    post '/sort' do
      section = params[:section]

      params[:order].each_with_index do |id, index|
        items = Base.where(_id: id)
        if items.count > 0
          item = items.first
          item.connections.where(:section => section).each do |connection| 
            connection.update_attribute(:order_id, index+1)
          end
          item.save
        end
      end
    end

    post '/save' do
      content_type :json
      errors = []
      params.each do |key, value|
        begin
          if value['id'] != nil
            record = Kernel.const_get(key).find(value['id'])
          else
            record = Kernel.const_get(key).new
          end
          record.update_attributes(value)
        rescue TypeError
        end
        if !record.save
          errors << record.errors.messages.to_json
        else
        end
      end
      return errors
    end
    post '/upload' do
      image = Image.new
      image.file = params[:Filedata][:tempfile].read
      image.file.name = params[:Filedata][:filename]
      if !image.save
        file = Document.new
        file.file = params[:Filedata][:tempfile].read
        file.file.name = params[:Filedata][:filename]
        file.save
      end

      return show(:images) + show(:files)
    end
    get '/images' do
      show :browse
    end
    post '/file/destroy' do
      image = Image.where(:id => params[:id]).first
      p image
      if image != nil
        image.destroy
      else
        Document.where(:id => params[:id]).first.destroy
      end
    end
    get '/ckeditor/files' do
      show :ckeditor
    end

    get '/*.:extention' do
      pass unless ['css', 'js'].include? params[:extention]
      response.headers['Cache-Control'] = 'public, max-age=86400'
      content_type params[:extention]
      show params[:splat].join
    end
  end
end
