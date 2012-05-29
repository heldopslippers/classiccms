require 'spec_helper'
require 'classiccms/cli'
describe :User do
  def app
    Classiccms.boot
    Classiccms::CMSController
  end
  before :all do
    clear_tmp
    discard { Classiccms::Cli.command ['new', 'app'] }
    Dir.chdir 'app'
    app
  end
  before :each do
    @user = build :user
  end
  describe :username do
    it 'should exsist' do
      @user.respond_to?(:username).should == true
    end
    it 'should fail when it has less then 3 characters' do
      @user.username = '12'
      @user.valid?.should == false
    end
    it 'should fail when it has more then 25 characters' do
      @user.username = '1' * 26
      @user.valid?.should == false
    end
    it 'should not accept nil' do
      @user.username = nil
      @user.valid?.should == false
    end
    it 'should be unique' do
      u = create :user
      @user.username = 'Simon'
      @user.valid?.should == false
    end
  end
  describe :password do
    it 'should exist' do
      @user.respond_to?(:password).should == true
    end
    it 'should be accepted' do
      @user.password = '123Simon'
      @user.valid?.should == true
    end
    it 'should fail when it has less then 3 characters' do
      @user.password = '12'
      @user.valid?.should == false
    end
    it 'should fail when it has more then 25 characters' do
      @user.password = '1' * 26
      @user.valid?.should == false
    end
    it 'should not accept nil' do
      @user.password = nil
      @user.valid?.should == false
    end
  end
end
