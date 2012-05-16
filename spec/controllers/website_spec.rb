require 'spec_helper'
require 'classiccms/application'
require 'classiccms/cli'

describe Classiccms do
  def app
    Classiccms.boot
    Classiccms::WebsiteController
  end
  before :all do
    clear_tmp
    discard { Classiccms::Cli.command ['new', 'app'] }
    Dir.chdir 'app'
    app
  end

  describe 'get /' do
    it 'should render application/index.erb if it is stated in the config' do
      string = "<h1>hello world</h1>\n"
      file 'erb', string do
        get '/'
        last_response.body.should == string
      end
    end
    it 'should render application/index.haml if it is stated in the config' do
      string = "%h1 hello world"
      file 'haml', string do
        get '/'
        last_response.body.should == "<h1>hello world</h1>\n"
      end
    end
    it 'should render appliacation/index.haml by default' do
      with_constants :CONFIG => {:home => nil} do
        set_file "views/application/index.haml", "%h1 hello world"
        get '/'
        last_response.body.should == "<h1>hello world</h1>\n"
      end
    end
    it 'should still render first item if home is defined' do
      with_constants :CONFIG => {:model => 'Article', :section => 'menu'} do 
        set_file "views/application/index.haml", "%h1 hello world"
        get '/'
        last_response.body.should == "<h1>hello world</h1>\n"
      end
    end
    it 'should render the item if model and section is defined' do
      with_constants :CONFIG => {:model => 'Menu', :section => 'menu'} do
        set_file "views/application/index.haml", "= layout 'menu'"

        #set model and require
        set_file "models/menu.rb", "class Menu < Base; end"
        create_dir 'views/menu'
        set_file "views/menu/test.haml", "%h1 hello world"
        require_models

        #create record
        m = Menu.new
        m.connections << Connection.new(:section => 'menu', :file => 'test.haml')
        m.save
        get '/'
        last_response.body.should == "<h1>hello world</h1>\n"
      end
    end
  end
  describe '/:id/?*' do
    it 'should return not found if id does not exist' do
      get '/test'
      last_response.body.should == '<h1>Not Found</h1>'
    end
    it 'should render the index if id is found' do
      string = "= @routes.first.to_s"
      file 'haml', string do
        #set model and require
        m = Menu.create(:connections => [Connection.new(:section => 'menu', :file => 'test.haml')])
        s = Slug.new(:document_id => m.id)
        s.generate_id
        s.save

        get "/0/test-hello-world"
        last_response.body.should == "#{m.id}\n"
      end
    end
  end

  describe 'js' do
    it 'should render coffeescript' do
      set_file "assets/js/index.coffee", "h = 24"
      get '/js/index.js'
      last_response.body.should match("var h;")
    end
    it 'should render js' do
      set_file "assets/js/index1.js", "function(){alert('hello');}"
      get '/js/index1.js'
      last_response.body.should == "function(){alert('hello');}\n"
    end
    it 'should except directories' do
      create_dir 'assets/js/test'
      set_file "assets/js/test/index1.js", "function(){alert('boom');}"
      get '/js/test/index1.js'
      last_response.body.should == "function(){alert('boom');}\n"
    end
  end
  describe 'css' do
    it 'should render sass' do
      set_file "assets/css/index.sass", ".main\n  :color white"
      get '/css/index.css'
      last_response.body.should == ".main {\n  color: white; }\n"
    end
    it 'should return css' do
      set_file "assets/css/index1.css", ".main{color: black;}"
      get '/css/index1.css'
      last_response.body.should == ".main{color: black;}\n"
    end
    it 'should except directories' do
      create_dir 'assets/css/test'
      set_file "assets/css/test/index1.css", "css"
      get '/css/test/index1.css'
      last_response.body.should == "css\n"
    end
  end

  describe 'public' do
    it 'should return the image' do
      set_file "public/test.png", "hello"
      get '/test.png'
      last_response.body.should == "hello\n"
    end
  end

  after :all do
    clear_tmp
  end
end
