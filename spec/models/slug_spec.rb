require 'spec_helper'
require 'classiccms/cli'

describe :Slug do
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
    @slug = Slug.new
  end
  describe :document_id do
    it 'should exist' do
      @slug.respond_to?(:document_id).should == true
    end
    it 'should always save it as BSON::ObjectId' do
      base = Base.create
      @slug.document_id = base.id.to_s
      @slug.document_id.should == base.id
    end
    it 'should check if given id exists' do
      base = Base.create
      base.delete
      @slug.document_id = base.id
      @slug.valid?.should == false
    end
    it 'should set error message when given id does not exist' do
      base = Base.create
      base.delete
      @slug.document_id = base.id
      @slug.valid?
      @slug.errors.messages[:document_id].should == ["id doesn't exist"]
    end
  end

  describe :generate_id do
    it 'should exist' do
      @slug.respond_to?(:generate_id).should == true
    end
    it 'should return a valid id' do
      @slug.generate_id.should == '0'
    end
    it 'should set a valid id' do
      @slug.generate_id
      @slug.id.should == '0'
    end
    it 'cannot generate an already existing id' do
      slug = Slug.new
      slug.document_id = Base.create.id
      slug.generate_id
      slug.save

      @slug.generate_id
      @slug.id.should_not == slug.id
    end
  end
  describe :set_id do
    it 'should exist' do
      @slug.respond_to?(:set_id).should == true
    end
    it 'should set the specified id' do
      @slug.set_id 'string'
      @slug.id.should == 'string'
    end
    it 'should remove exissting slugs with the same id' do
      slug = Slug.create _id: 'string', document_id: Base.create.id
      

      @slug.set_id 'string'
      @slug.save

      Slug.all.count.should == 1
    end
    it 'should sanetize the slug' do
      @slug.set_id 'test test'
      @slug.id.should == 'test-test'
    end
    it 'should remove upercase letters' do
      @slug.set_id 'Test'
      @slug.id.should == 'test'
    end
  end
end
