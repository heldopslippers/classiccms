require 'spec_helper'
describe Connection do
  before :each do
    @connection = Connection.new
    @connection.parent_id = Base.create.id
  end
  describe :order_id do
    it 'should exsist' do
      @connection.respond_to?(:order_id).should == true
    end
    it 'should allow an integer' do
      @connection.order_id = 3
      @connection.valid?.should == true
    end
    it 'should not allow negative integers' do
      @connection.order_id = -3
      @connection.valid?.should == false
    end
    it 'should not allow a string' do
      @connection.order_id = 'string'
      @connection.valid?.should == false
    end
    it 'should set 0 as default' do
      @connection.order_id.should == 0
    end
  end
  describe :parent_id do
    it 'should exsist' do
      @connection.respond_to?(:parent_id).should == true
    end
    it 'should except an existing BSON_ID' do
      base = Base.new
      base.save
      @connection.parent_id = base.id
      @connection.valid?.should == true
    end
    it 'should no except a non existing id' do
      base = Base.new

      @connection.parent_id = base.id
      @connection.valid?.should == false
    end
    it 'should except an existing id as a string' do
      base = Base.new
      base.save
      @connection.parent_id = base.id.to_s
      @connection.valid?.should == true
    end
    it 'should transform an existing id if sumbited as string' do
      base = Base.new
      base.save
      @connection.parent_id = base.id.to_s
      @connection.valid?
      @connection.parent_id.should == base.id
    end
    it 'should except nil as parent_id' do
      @connection.parent_id = nil
      @connection.valid?.should == true
    end
  end

  describe :file_name do
    it 'should exsist' do
      @connection.respond_to?(:file).should == true
    end
    it 'should always be a string' do
      @connection.file = 3
      @connection.file.should == '3'
    end
  end

  describe :section do
    it 'should exsist' do
      @connection.respond_to?(:section).should == true
    end
    it 'should always be a string' do
      @connection.file = 3
      @connection.file.should == '3'
    end
  end
end
