require 'spec_helper'
require 'classiccms/application'
require 'classiccms/cli'
require 'classiccms/lib/routing'
require 'classiccms/helpers'

describe Classiccms do
  include Classiccms::Routing
  def app
    Classiccms.boot
    Classiccms::ApplicationController
  end
  before :all do
    clear_tmp
    discard { Classiccms::Cli.command ['new', 'app'] }
    Dir.chdir 'app'
    app

    set_file "models/menu.rb", "class Menu < Base; end"
    require_models
  end

  describe 'get_first_item' do
    it 'should return nil when no items are found' do
      with_constants :CONFIG => {:model=> 'Menu', :section => 'menu'} do
        get_first_item.should == nil
      end
    end
    it 'should return nil model is not set' do
      with_constants :CONFIG => {:model=> nil, :section => 'menu'} do
        m = Menu.create connections: [Connection.new(section: 'menu')]
        get_first_item.should == nil
      end
    end
    it 'should return nil model is not set' do
      with_constants :CONFIG => {:model=> nil, :section => 'menu'} do
        m = Menu.create connections: [Connection.new(section: 'menu')]
        get_first_item.should == nil
      end
    end
    it 'should return item id' do
      with_constants :CONFIG => {:model=> 'Menu', :section => 'menu'} do
        m = Menu.create connections: [Connection.new(section: 'menu')]
        get_first_item.should == m
      end
    end
    it 'should return item id with lowest order_id' do
      with_constants :CONFIG => {:model=> 'Menu', :section => 'menu'} do
        m1 = Menu.create connections: [Connection.new(section: 'menu', order_id: 0)]
        m2 = Menu.create connections: [Connection.new(section: 'menu', order_id: 1)]
        get_first_item.should == m1
      end
    end
  end
  describe 'get_route' do
    it 'should not do anything when current record is nil' do
      get_route(0).should  == []
    end
    it 'should not accept a string' do
      get_route('').should  == []
    end
    it 'should return current routes when current item is rejected' do
      get_route('', ['hello']).should  == ['hello']
    end
    it 'should return the item when valid' do
      m = Menu.create connections: [Connection.new]
      get_route(m).should  == [m.id]
    end
    it 'should also return the parent' do
      m1 = Menu.create connections: [Connection.new]
      m2 = Menu.create connections: [Connection.new(parent_id: m1.id)]
      get_route(m2).should  == [m2.id, m1.id]
    end
    it 'should return something' do
      m1 = Menu.create connections: [Connection.new(parent_id: nil)]
      get_route(m1).should  == [m1.id]
    end
  end
end
