require 'spec_helper'
require 'classiccms/application'
require 'classiccms/cli'

describe Classiccms do
  def app
    Classiccms.boot
    Classiccms::CMSController
  end
  before :all do
    clear_tmp
    discard { Classiccms::Cli.command ['new', 'app'] }
    Dir.chdir 'app'
    app

    #set model and require
    set_file "models/menu.rb", "class Menu < Base; field :name, input: 'input'; validates_length_of :name, maximum: 10; end"
    create_dir 'views/menu'
    set_file "views/menu/test.haml", "%h1 hello world"
    require_models
  end

  describe 'add' do
    it 'should return nothing when cms param is empty' do
      post '/add'
      last_response.body.should == ''
    end
    it 'should return nothing when cms params can not be decrypted' do
      post '/add', {:cms => ''}
      last_response.body.should == ''
    end
    it 'should return html' do
      login
      m = Menu.new
      string = Base64.encode64([[Menu, 0, 'hello']].to_s.encrypt)
      post '/add', {:cms => string}
      last_response.body.should match("class='background'")
    end
    it 'should not include id input if record is new' do
      login
      m = Menu.new
      string = Base64.encode64([[Menu, 0, 'hello']].to_s.encrypt)
      post '/add', {:cms => string}
      last_response.body.should_not match("name='input'")
    end
    it 'should return name key' do
      login
      m = Menu.new
      string = Base64.encode64([[Menu, 0, 'hello']].to_s.encrypt)
      post '/add', {:cms => string}
      last_response.body.should match("[Menu][name]")
    end
    it 'should include file name for connections' do
      login
      m = Menu.new
      string = Base64.encode64([[Menu, 0, 'hello']].to_s.encrypt)
      post '/add', {:cms => string}
      last_response.body.include?("name='[Menu][connections][][file]'").should == true
    end
    it 'should include section for file' do
      login
      m = Menu.new
      string = Base64.encode64([[Menu, 0, 'hello']].to_s.encrypt)
      post '/add', {:cms => string}
      last_response.body.should match("value='hello'")
    end
    it 'should have the form pointed to cms/create' do
      login
      m = Menu.new
      string = Base64.encode64([[Menu, 0, 'hello']].to_s.encrypt)
      post '/add', {:cms => string}
      last_response.body.should match("action='/cms/create'")
    end
  end

  describe 'edit' do
    it 'should not return anything if id does not exist' do
      login
      post '/edit', {:cms => ''}
      last_response.body.should == ''
    end
    it 'should display delete button' do
      login
      post '/edit', {:cms => Menu.create.id}
      last_response.body.should match("class='delete'")
    end
    it 'should set form action for update' do
      login
      post '/edit', {:cms => Menu.create.id}
      last_response.body.should match("action='/cms/update'")
    end
    it 'should add hidden input for id' do
      login
      post '/edit', {:cms => Menu.create.id}
      last_response.body.should match("[Menu][id]")
    end
  end

  describe 'destroy' do
    it 'should return nothing if id does not exist' do
      login
      post '/destroy', {:id => ''}
      last_response.body.should == ''
    end
    it 'should delete the id' do
      login
      m = Menu.create
      post '/destroy', {:id => m.id}
      Menu.all.count.should == 0
    end
  end

  describe 'sort' do
    it 'should set the appropriate order_ids' do
      login
      m1 = Menu.create(:connections => [Connection.new(:section => 'menu')])
      m2 = Menu.create(:connections => [Connection.new(:section => 'menu')])

      post '/sort', {:section => 'menu', :order => [m2.id, m1.id]}
      Menu.find(m1.id).connections.first.order_id.should == 2
      Menu.find(m2.id).connections.first.order_id.should == 1
    end
  end
  describe 'create' do
    before :each do
      login
      post '/save', {:Menu => {:name => 'hello', :connections_attributes => [{:section => 'menu'}]}}
    end
    it 'should save the item' do
      Menu.all.count.should == 1
    end
    it 'should set the name attribute' do
      Menu.first.name.should == 'hello'
    end
    it 'should have created the connections' do
      Menu.first.connections.count.should == 1
    end
    it 'should contain a connection with section menu' do
      Menu.first.connections.first.section.should == 'menu'
    end
    it 'should return errors when creation fails' do
      post '/save', {:Menu => {:name => 'woohooooooooooooooooooooo', :connections_attributes => [{:section => 'menu'}]}}
      last_response.body.should == "{\"name\":[\"is too long (maximum is 10 characters)\"]}"
    end
  end
  describe 'save' do
    before :each do
      login
      m = Menu.create
      post '/save', {:Menu => {:id => m.id, :name => 'hello', :connections_attributes => [{:section => 'menu'}]}}
    end
    it 'should save the item' do
      Menu.all.count.should == 1
    end
    it 'should set the name attribute' do
      Menu.first.name.should == 'hello'
    end
    it 'should have created the connections' do
      Menu.first.connections.count.should == 1
    end
    it 'should contain a connection with section menu' do
      Menu.first.connections.first.section.should == 'menu'
    end
    it 'should return errors when creation fails' do
      m = Menu.create
      post '/save', {:Menu => {:id => m.id, :name => 'woohooooooooooooooooooooo', :connections_attributes => [{:section => 'menu'}]}}
      last_response.body.should == "{\"name\":[\"is too long (maximum is 10 characters)\"]}"
    end
  end

  describe 'upload' do
    before :each do
      @cat = Rack::Test::UploadedFile.new(File.join(File.dirname(__FILE__), '/../../spec/assets/cat.jpg'), 'image/jpg')
      @txt = Rack::Test::UploadedFile.new(File.join(File.dirname(__FILE__), '/../../spec/assets/cat.txt'), 'image/jpg')
    end
    it 'should upload return the new image' do
      login
      post '/upload/image', {:Filedata => @cat}
      Image.count.should == 1
    end
    it 'should have save the image' do
      login
      post '/upload/image', {:Filedata => @cat}
      image = Image.last
      image.file.size.should == 34503
    end
    it 'should not save the image if it is not an image' do
      login
      post '/upload/image', {:Filedata => @txt}
      Image.count.should == 0
    end
  end

  describe 'js' do
    it 'should render coffeescript' do
      get '/js/index.js'
      last_response.body.should match("cms")
    end
    it 'should render js' do
      get '/js/swfobject.js'
      last_response.body.should match("swf")
    end
  end
  describe 'css' do
    it 'should render sass' do
      get '/css/reset.css'
      last_response.body.should match("iki")
    end
  end
  describe 'public' do
    it 'should return the image' do
      get '/images/cancel.png'
      last_response.body.should match("PNG")
    end
  end

  after :all do
    #clear_tmp
  end
end
