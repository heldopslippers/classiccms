require 'spec_helper'
require 'classiccms/cli'
require 'stringio'

describe Base do
  before :each do
    clear_tmp
  end

  it "should test if fileUtiles is included" do
    defined?(FileUtils).should == 'constant'
    FileUtils.class.should == Module
  end
  it "should display an help message when the app name isn't displayed" do
    capture_log do
      Classiccms::Cli.command ['new']
      $stdout.string.should == "hmm you are using the command wrong: classicCMS new [app name]\n"
    end
  end
  it "should display error message when app name already exist" do
    capture_log do
      Dir.mkdir 'app'
      Classiccms::Cli.command ['new', 'app']
      $stdout.string.should == "hmm I think that app already exists!\n"
    end
  end
  it "should display message when command is finished" do
    capture_log do
      app_name = 'app'
      Classiccms::Cli.command ['new', app_name]
      $stdout.string.should == "#{app_name} created!\n"
    end
  end
  it "should create a directory with app name" do
    capture_log do
      app_name = 'app'
      Classiccms::Cli.command ['new', app_name]

      File.directory?(app_name).should == true
    end
  end
  it "should create public directory" do
    capture_log do
      app_name = 'app'
      Classiccms::Cli.command ['new', app_name]

      File.directory?(app_name + '/public').should == true
    end
  end
  it "should create views directory" do
    capture_log do
      app_name = 'app'
      Classiccms::Cli.command ['new', app_name]

      File.directory?(app_name + '/views').should == true
    end
  end

  it "should display error message that this isn't an app" do
    capture_log do
      Classiccms::Cli.command ['server']
      $stdout.string.should == "not an app! Try running:\nclassicCMS new [app name]\n"
    end
  end
  it "should display message that server is booting" do
    app_name = 'app'
    #create app
    discard { Classiccms::Cli.command ['new', app_name] }
    #cd into it
    Dir.chdir app_name
    capture_log do
      #boot
      Classiccms::Cli.command ['server']
      #check message
      $stdout.string.should == "Going to start server...\n"
    end
  end
  it "should test if models are included" do
    setup_app 'app' do
      discard do
        Classiccms::Cli.command ['server']
        defined?(Base).should == 'constant'
        Base.class.should == Class
      end
    end
  end
  it "should display an error message when command isn't recognized" do
    capture_log do
      Classiccms::Cli.command ['nonexistant']
      $stdout.string.should == "you are so smart! I don't know what you mean! (try using new or server)\n"
    end
  end

  after :all do
    clear_tmp
  end
end
