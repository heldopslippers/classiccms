require 'spec_helper'
require 'classiccms/application'
require 'classiccms/cli'
require 'classiccms/helpers'

describe Classiccms do
  include Classiccms::Helpers
  def app
    Classiccms.boot
    Classiccms::WebsiteController
  end
  before :all do
    clear_tmp
    discard { Classiccms::Cli.command ['new', 'app'] }
    Dir.chdir 'app'
    app

    #set model and require
    set_file "models/menu.rb", "class Menu < Base; end"
    require_models
  end

  it 'should render pong' do
    with_constants :CONFIG => {:home => 'application/index1'} do
      set_file "views/application/index1.haml", "= ping"
      get '/'
      last_response.body.should == "pong\n"
    end
  end
  describe 'cms helper' do
    it 'should not render cms if not logged in' do
      with_constants :CONFIG => {:home => 'application/cms'} do
        set_file 'views/application/cms.haml', "= cms"
        get '/'
        last_response.body.should_not match('script')
      end
    end
    it 'should render cms if logged in' do
      with_constants :CONFIG => {:home => 'application/cms'} do
        login
        set_file 'views/application/cms.haml', "= cms"
        get '/'
        last_response.body.should match('script')
      end
    end
  end
  it 'should render the logout button when logedin' do
    with_constants :CONFIG => {:home => 'application/logout'} do
      set_file 'views/application/logout.haml', "= logout"
      login
      get '/'
      last_response.body.should match('/logout')
    end
  end
  it 'should not render the logout button' do
      with_constants :CONFIG => {:home => 'application/logout'} do
        set_file 'views/application/logout.haml', "= logout"
        get '/'
        last_response.body.should == "\n"
      end
  end
  describe 'slug helper' do
    it 'should send back a slug url with 0' do
      link(Menu.create, 'test').should == '/0/test'
    end
    it 'should generete a unique slug' do
      link(Menu.create, 'test').should == '/0/test'
      link(Menu.create, 'test').should == '/1/test'
    end
    it 'should give the same url when asked for it twice' do
      m = Menu.create
      link(m, 'test').should == link(m, 'test')
    end
  end
  describe 'show helper' do
    it 'should render the partial file' do
      with_constants :CONFIG => {:home => 'application/show'} do
        set_file 'views/application/show.haml', "= show 'application/partial'"
        set_file 'views/application/partial.haml', '%h1 partial'
        get '/'
        last_response.body.should == "<h1>partial</h1>\n"
      end
    end
  end
  describe 'layout helper' do
    it 'should return 404 when section does not exist' do
      @routes = [Menu.create.id]
      layout('menu', 1).should == '404'
    end
    it 'should return when there are no records' do
      @routes = []
      layout('menu', 1).should == '404'
    end
    it 'should return 404 when section exist but no file name is given' do
      m = Menu.create(connections: [Connection.new(section: 'menu')])
      @routes = [m.id]
      layout('menu', 1).should == '404'
    end
    it 'should return the rendered file' do
      with_constants :CONFIG => {home: 'application/index4', model: 'Menu', section: 'menu'} do
        set_file "views/application/index4.haml", "= layout 'menu', 1"
        create_dir 'views/Menu'
        set_file "views/Menu/index.haml", "%h1 menu"

        m = Menu.create connections: [Connection.new(section: 'menu', file: 'index')]

        get '/'
        last_response.body.should == "<h1>menu</h1>\n"
      end
    end
    it 'should also pass the current record' do
      with_constants :CONFIG => {home: 'application/index4', model: 'Menu', section: 'menu'} do
        set_file "views/application/index4.haml", "= layout 'menu', 1"
        create_dir 'views/menu'
        set_file "views/menu/record.haml", "%h1= record.id"

        m = Menu.create connections: [Connection.new(section: 'menu', file: 'record')]

        get '/'
        last_response.body.should == "<h1>#{m.id}</h1>\n"
      end

    end
  end
  describe 'section helper' do
    it 'should return nothing when section does not exist' do
      @routes = [Menu.create.id]
      section('menu', 0).should == ''
    end
    it 'should return nothing when file does not exist' do
      m = Menu.create connections: [Connection.new(section: 'menu')]
      @routes = [m.id]
      section('menu', 0).should == ''
    end
    it 'should return the rendered file' do
      with_constants :CONFIG => {home: 'application/index5'} do
        set_file "views/application/index5.haml", "= section 'menu', 0"
        create_dir 'views/menu'
        set_file "views/menu/section.haml", "%h1 menu"

        m = Menu.create connections: [Connection.new(section: 'menu', file: 'section')]

        get '/'
        last_response.body.should == "<h1>menu</h1>\n"
      end
    end
    it 'should add local variable record' do
      with_constants :CONFIG => {home: 'application/index5'} do
        set_file "views/application/index5.haml", "= section 'menu', 0"
        create_dir 'views/menu'
        set_file "views/menu/section1.haml", "%h1= record.id"

        m = Menu.create connections: [Connection.new(section: 'menu', file: 'section1')]

        get '/'
        last_response.body.should == "<h1>#{m.id}</h1>\n"
      end
    end
    it 'should return items base upon order_id' do
      with_constants :CONFIG => {home: 'application/index5'} do
        set_file "views/application/index5.haml", "= section 'menu', 0"
        create_dir 'views/menu'
        set_file "views/menu/section2.haml", "%h1= record.id"

        m1 = Menu.create connections: [Connection.new(order_id: 0, section: 'menu', file: 'section2')]
        m2 = Menu.create connections: [Connection.new(order_id: 1, section: 'menu', file: 'section2')]

        get '/'
        last_response.body.should == "<h1>#{m1.id}</h1>\n<h1>#{m2.id}</h1>\n"
      end
    end
  end
  describe :add do
    it 'should reject if session user_id is not set' do
      m = Menu.create
      @routes = [m.id]
      add([Menu, 0, :name]).should == nil
    end
    it 'should return html' do
      file 'haml', "= add [Menu, 0, 'hello']" do
        m = Menu.create
        user = create :user
        post '/login', :username => user.username, :password => user.password

        get '/'
        last_response.body.should match("make")
      end
    end
    it 'should return a valid encryption key' do
      file 'haml', "= add [Menu, 0, 'hello']" do
        m = Menu.create
        user = create :user
        post '/login', :username => user.username, :password => user.password

        get '/'
        encrypted = "JMiQb770XXy0IkW1tSvoAhORd6mUwRlW0po6HeFRDgU="
        last_response.body.should match(encrypted)
      end
    end
  end
  describe :edit do
    it 'should reject if id does not exist' do
      edit('id').should == nil
    end
    it 'should reject if session user_id is not set' do
      m = Menu.create
      @routes = [m.id]
      edit(m.id).should == nil
    end
    it 'should return html' do
      with_constants :CONFIG => {home: 'application/index7'} do
        m = Menu.create
        set_file "views/application/index7.haml", "= edit '#{m.id}'"

        user = create :user
        post '/login', :username => user.username, :password => user.password

        get '/'
        last_response.body.should match("Edit")
      end
    end
  end
  describe :sort do
    it 'should reject if id does not exist' do
      sort('id').should == nil
    end
    it 'should reject if session user_id is not set' do
      m = Menu.create
      sort(m.id).should == nil
    end
    it 'should return html' do
      with_constants :CONFIG => {home: 'application/index8'} do
        m = Menu.create
        set_file "views/application/index8.haml", "= sort '#{m.id}'"

        user = create :user
        post '/login', :username => user.username, :password => user.password

        get '/'
        last_response.body.should == "#{m.id}\n"
      end
    end
  end

  after :all do
    clear_tmp
  end
end
