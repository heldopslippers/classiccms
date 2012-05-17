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

  it 'get /login should render login page' do
    get '/login'
    last_response.body.should match('login')
  end
  describe 'post /login' do
    it 'should return id if it user exist' do
      with_constants :CONFIG => {:home => 'application/index10'} do
        set_file "views/application/index10.haml", "= session[:user_id]"
        u = create :user
        post '/login', {:username => u.username, :password => u.password}
        follow_redirect!
        last_response.body.should == "#{u.id}\n"
      end
    end
    it 'should return to / if user does exist' do
      file 'haml', '' do
        u = create :user
        post '/login', {:username => u.username, :password => u.password}
        follow_redirect!
        last_request.url.should == 'http://example.org/'
      end
    end
    it 'should go to /correct if correct param is set' do
      file 'haml', '' do
        u = create :user
        post '/login', {:username => u.username, :password => u.password, :correct => '/correct'}
        follow_redirect!
        last_request.url.should == 'http://example.org/correct'
      end
    end
    it 'should go to / if incorrect param is not set' do
      file 'haml', '' do
        u = create :user
        post '/login', {}
        follow_redirect!
        last_request.url.should == 'http://example.org/login'
      end
    end
    it 'should go to / if incorrect param is not set' do
      file 'haml', '' do
        u = create :user
        post '/login', {}
        follow_redirect!
        last_request.url.should == 'http://example.org/login'
      end
    end
  end
  it 'logout should destroy all session variables' do
    with_constants :CONFIG => {:home => 'application/index10'} do
      set_file "views/application/index10.haml", "= session[:user_id]"
      u = create :user
      post '/login', {:username => u.username, :password => u.password}
      follow_redirect!
      last_response.body.should == "#{u.id}\n"
      get '/logout'
      follow_redirect!
      last_response.body.should == "\n"
    end
  end

  after :all do
    clear_tmp
  end
end
