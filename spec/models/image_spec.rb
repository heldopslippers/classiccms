require 'spec_helper'
require 'classiccms/application'
require 'classiccms/cli'

describe 'Image' do
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

  it 'should upload an image' do
    image = Image.new
    image.file = File.open(File.join(File.dirname(__FILE__),'/../../spec/assets/cat.jpg'))
    image.save
    image.file.size.should == 34503
  end
  it 'should only accept images' do
    image = Image.new
    image.file = File.open(File.join(File.dirname(__FILE__),'/../../spec/assets/cat.txt'))
    image.save.should == false
  end
end
