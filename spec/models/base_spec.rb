require 'spec_helper'
describe 'Base' do
  before :each do
    @base = Base.new
  end
  describe :modules do
    it 'should include Mongoid document module' do
      @base.respond_to?(:id).should == true
    end
    it 'should respond to create_at' do
      @base.respond_to?(:created_at).should == true
    end
    it 'should respond to updated_at' do
      @base.respond_to?(:updated_at).should == true
    end
    it 'should respond to version' do
      @base.respond_to?(:version).should == true
    end
    it 'should stil exist when deleted' do
      @base.save
      @base.delete
      Base.deleted.count.should == 1
    end
  end
  it 'should have a default scope based on created ascending' do
    b1 = Base.new
    b2 = Base.new
    b1.save
    b2.save

    Base.all.last.should == b2
  end
  it 'should have embeded connections' do
    @base.connections.should == []
  end
  it 'should remove the slugs if the document gets destroyed' do
    b1 = Base.create
    Slug.create(:document_id => b1.id)
    Slug.count.should == 1
    b1.destroy!

    Slug.count.should == 0
  end
  it 'should should remove the connections linking to the document' do
    b1 = Base.create
    b2 = Base.create(:connections => [Connection.new(:parent_id => b1.id), Connection.new()])
    b1.destroy
    Base.find(b2.id).connections.count.should == 1
  end
end
