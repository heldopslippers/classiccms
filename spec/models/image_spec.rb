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
    image.image = File.open(File.join(File.dirname(__FILE__),'/../../spec/assets/cat.jpg'))
    image.save
    File.exists?("public/assets/images/#{image.id}.jpg").should == true
  end
  it 'should not except normal files' do
    image = Image.new
    begin
      image.store!(File.open(File.join(File.dirname(__FILE__),'/../../spec/assets/cat.txt')))
    rescue
    end
    File.exists?("public/assets/images/#{image.id}.txt").should == false
  end
  it 'should have set the url' do
    image = Image.new
    image.store!(File.open(File.join(File.dirname(__FILE__),'/../../spec/assets/cat.jpg')))
    image.save
    File.exists?("public/assets/images/#{image.id}.jpg").should == true
  end
  it 'should set the url' do
    image = Image.new
    image.store!(File.open(File.join(File.dirname(__FILE__),'/../../spec/assets/cat.jpg')))
    image.save
    image.url.should == "/assets/images/#{image.id}.jpg"
  end
  it 'should delete the image' do
    image = Image.new
    image.store!(File.open(File.join(File.dirname(__FILE__),'/../../spec/assets/cat.jpg')))
    image.save
    image.destroy
    File.exists?("public/assets/images/#{image.id}.jpg").should == false
  end
end
