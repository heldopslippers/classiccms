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

    #set queue file

    set_file "queue/test.rb", %Q(
      class Test
        @queue = :mail
        def self.perform
          p 'hello world'
        end
      end
    )
    app
    Resque.inline = true
  end

  it 'should have Mail class' do
    defined?(Test).should == 'constant'
    Test.class == Class
  end
  it 'should be able to run background task' do
    capture_log do
      Resque.enqueue Test
      $stdout.string.should == "\"hello world\"\n"
    end
  end
  it 'should have a Rakefile' do
    File.exists?("#{Classiccms::ROOT}/scaffold/Rakefile").should == true
  end
  it 'should have an example queue' do
    File.exists?("#{Classiccms::ROOT}/scaffold/app/queue/mail.rb").should == true
  end


  after :all do
    clear_tmp
  end
end
